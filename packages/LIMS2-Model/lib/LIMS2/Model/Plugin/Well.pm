package LIMS2::Model::Plugin::Well;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use Hash::MoreUtils qw( slice slice_def );
use Scalar::Util qw( blessed );
use List::MoreUtils qw( before_incl );
use namespace::autoclean;
use LIMS2::Model::Error::Database;

requires qw( schema check_params throw );

sub check_parent_plate_type {
    my ( $self, $well, $parent_wells ) = @_;

    my $constraint = $well->plate->plate_type . '_parent_plate_type';

    for my $pw ( @{ $parent_wells } ) {
        $self->check_params( { plate_type => $pw->plate->plate_type },
                             { plate_type => { validate => $constraint } } );
    }
}

sub pspec_create_well {
    return {
        plate_name     => { validate => 'plate_name' },
        name           => { validate => 'well_name' },
        created_by     => { validate => 'existing_user', post_filter => 'user_id_for' },
        created_at     => { validate => 'date_time', optional => 1, post_filter => 'parse_date_time' },
        assay_pending  => { validate => 'date_time', optional => 1, post_filter => 'parse_date_time' },
        assay_complete => { validate => 'date_time', optional => 1, post_filter => 'parse_date_time' },
        accepted       => { optional => 1 },
        parent_wells   => { optional => 1, default => [] },
        assay_results  => { optional => 1, default => [] },
        pipeline       => { optional => 1, validate => 'existing_pipeline', post_filter => 'pipeline_id_for' }
    };
}

# Internal function, returns a LIMS2::Model::Schema::Result::Well object
sub _instantiate_well {
    my ( $self, $params ) = @_;

    if ( blessed( $params ) and $params->isa( 'LIMS2::Model::Schema::Result::Well' ) ) {
        return $params;
    }

    #TODO: check this
    my $validated_params = $self->check_params(
        { slice( $params, qw( plate_name well_name ) ) },
        { plate_name => {}, well_name  => {} }
    );

    $self->retrieve( Well => $validated_params, { join => 'plate', prefetch => 'plate' } );
}

# Internal function, creates entries in the tree_paths table
sub _create_tree_paths {
    my ( $self, $well, @ancestors ) = @_;

    my ( $insert_tree_paths, @bind_params );

    if ( @ancestors ) {
        $self->check_parent_plate_type( $well, \@ancestors );
        $insert_tree_paths = sprintf( <<'EOT', join q{, }, ('?')x@ancestors );
insert into tree_paths( ancestor, descendant, path_length )
  select t.ancestor, cast( ? as integer ), t.path_length + 1
  from tree_paths t
  where t.descendant in ( %s )
union all
  select cast( ? as integer ), cast( ? as integer ), 0
EOT
        @bind_params = ( $well->id, map( $_->id, @ancestors ), $well->id, $well->id );
    }
    else {
        $insert_tree_paths = <<'EOT';
insert into tree_paths( ancestor, descendant, path_length ) values( ?, ?, 0 )
EOT
        @bind_params = ( $well->id, $well->id );
    }

    $self->schema->storage->dbh_do(
        sub {
            my $sth = $_[1]->prepare_cached( $insert_tree_paths );
            $sth->execute( @bind_params );
        }
    );
}

# Internal function, returns LIMS2::Model::Schema::Result::Well object
sub _create_well {
    my ( $self, $validated_params, $process, $plate ) = @_;

    # TODO: check how this is called, better to pass well_name or name
    $plate ||= $self->_instantiate_plate( $validated_params );

    $self->log->debug( '_create_well: ' . $plate->name . '_' . $validated_params->{name} );

    my $well = $plate->create_related(
        wells => {
            slice_def( $validated_params, qw( name created_by created_at assay_pending ) ),
            process_id => $process->id
        }
    );

    $self->log->debug( 'created well with id: ' . $well->id );

    $self->_create_tree_paths( $well, map { $self->_instantiate_well( $_ ) } @{ $validated_params->{parent_wells} } );

    if ( $validated_params->{pipeline} ) {
        $process->create_related(
            process_pipeline => { id => $validated_params->{pipeline} }
        );
    }

    for my $assay_result ( @{ $validated_params->{assay_results} } ) {
        $self->add_well_assay_result( $assay_result, $well );
    }

    if ( $validated_params->{assay_complete} ) {
        $self->set_well_assay_complete( { assay_complete => $validated_params->{assay_complete} }, $well );
    }

    if ( $validated_params->{accepted} ) {
        $self->set_well_accepted_override( $validated_params->{accepted}, $well );
    }

    return $well;
}

sub pspec_set_well_assay_complete {
    return {
        assay_complete => { validate    => 'date_time',
                            optional    => 1,
                            default     => sub { DateTime->now },
                            post_filter => 'parse_date_time'
                        }
    };
}

sub set_well_assay_complete {
    my ( $self, $params, $well ) = @_;

    $well ||= $self->_instantiate_well( $params );

    my $validated_params = $self->check_params( { slice_def( $params, 'assay_complete' ) },
                                                $self->pspec_set_well_assay_complete );

    # XXX fire trigger to set 'accepted' flag

    $well->update( { assay_complete => $validated_params->{assay_complete} } );
}

sub pspec_set_well_accepted_override {
    return {
        accepted   => { validate => 'boolean' },
        created_by => { validate => 'existing_user', post_filter => 'user_id_for' },
        created_at => { validate => 'date_time', post_filter => 'parse_date_time' }
    };
}

sub set_well_accepted_override {
    my ( $self, $params, $well ) = @_;

    $well ||= $self->_instantiate_well( $params );

    my $validated_params = $self->check_params(
        { slice_def( $params, qw( accepted created_by created_at ) ) },
        $self->pspec_set_well_accepted_override
    );

    unless ( $well->assay_complete ) {
        $self->throw( InvalidState => 'Cannot override accepted unless assay_complete' );
    }

    $well->search_related_rs( 'well_accepted_override' )->delete;

    my $accepted_override = $well->create_related( well_accepted_override => $validated_params );

    return $accepted_override;
}

# XXX These validations do not check that assay/result is a valid combination, only the
# two fields independently
sub pspec_add_well_assay_result {
    return {
        assay      => { validate => 'existing_assay' },
        result     => { validate => 'existing_assay_result' },
        created_by => { validate => 'existing_user', post_filter => 'user_id_for' },
        created_at => { validate => 'date_time', post_filter => 'parse_date_time' }
    };
}

sub add_well_assay_result {
    my ( $self, $params, $well ) = @_;

    $well ||= $self->_instantiate_well( $params );

    my $validated_params = $self->check_params(
        { slice_def( $params, qw( assay result created_by created_at ) ) },
        $self->pspec_add_well_assay_result
    );

    if ( $well->assay_complete ) {
        $self->throw( InvalidState => 'Assay results cannot be added to a well in state assay_complete' );
    }

    my $assay_result = $well->create_related( well_assay_results => $validated_params );

    unless ( $well->assay_pending and $well->assay_pending <= $assay_result->created_at ) {
        $well->update( { assay_pending => $assay_result->created_at } );
    }

    return $assay_result;
}

=head1 Delete Well

Delete a well, its linked data  and all its corresponding process

=cut

sub delete_well {
    my ( $self, $well ) = @_;
    $self->log->debug('deleting well: ' . $well->name );

    my $process_linked_multiple_wells = $self->_check_process_linked_to_multiple_well( $well );

    $self->_check_tree_paths( $well );
    $self->_check_process( $well );
    $self->_delete_sub_process( $well ) unless $process_linked_multiple_wells;
    $self->_delete_well( $well );


    $self->_delete_process( $well ) unless $process_linked_multiple_wells;
}

sub _delete_well {
    my ( $self, $well ) = @_;

    $self->log->debug('.. deleting well and its related data');
    my @related_well_data = qw(
        tree_paths_ancestors
        tree_paths_descendants
        well_legacy_qc_test_result
        well_assay_results
        well_accepted_override
    );

    for my $related_data_type ( @related_well_data ) {
        my $related_data_rs = $well->$related_data_type;
        if ( $related_data_rs ) {
            $related_data_rs->delete;
        }
    }

    $well->delete;
}

sub _check_process_linked_to_multiple_well {
    my ( $self, $well ) = @_;

    my $linked_wells_rs = $well->process->wells;
    if ( $linked_wells_rs->count == 1 ) {
        return;
    }
    else {
        my @well_names = map { $_->name } $linked_wells_rs->all;
        $self->log->info(' .. not deleting process, linked to other well: ' . join(',', @well_names) );
        return 1;
    }
}

sub _check_tree_paths {
    my ( $self, $well ) = @_;

    # check for well descendants
    my $descendants_rs = $well->tree_paths_ancestors->search_rs( { path_length => { '>', 0 } } );
    if ( $descendants_rs->count ) {
        LIMS2::Model::Error::Database->throw(
            sprintf 'Well %s (%d) has descendant wells, cannot delete',
            $well->name, $well->id
        );
    }
}

sub _check_process {
    my ( $self, $well ) = @_;

    #the tree paths check might catch everything, not sure, but lets check the
    #processes we know are linked to wells to be sure
    my @processes = qw( process_2w_gateways process_3w_gateways process_int_recoms process_rearray_source_wells );

    for my $process ( @processes ) {
        my $process_rs = $well->$process;
        if ( $process_rs->count > 0 ) {
            LIMS2::Model::Error::Database->throw( sprintf 'Well %s (%d) has a %s linked to it, cannot delete',
                                                  $well->name, $well->id, $process );
        }
    }
}

sub _delete_sub_process {
    my ( $self, $well ) = @_;

    #delete the process and any rows tied into this
    my $process = $well->process;
    my $process_type = $process->process_type;
    my $sub_process = $process->get_process;

    if ( $process_type eq 'rearray' ) {
        $self->log->debug('.. deleting rearray process');
        $sub_process->process_rearray_source_wells->delete;
        $sub_process->delete; # can we get this to cascade delete the process_rearray_source_wells
    }
    elsif ( $process_type eq 'int_recom' ) {
        $self->log->debug('.. deleting int_recom process');
        $sub_process->delete;
    }
    else {
        LIMS2::Model::Error::Database->throw( sprintf 'Well %s (%d) is from a %s, unable to delete yet',
                                              $well->name, $well->id, $process_type );
    }
}

sub _delete_process {
    my ( $self, $well ) = @_;

    my $process = $well->process;
    $self->log->debug('.. deleting process');
    my $process_pipeline = $process->process_pipeline;
    $process_pipeline->delete if $process_pipeline;

    #check and delete any synthetic_construct processes
    if ( my $synth_construct_process = $process->process_synthetic_construct ) {
        $synth_construct_process->delete;
    }

    $process->delete;
}
1;

__END__
