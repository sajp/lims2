package LIMS2::Model::Plugin::Plate;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use Hash::MoreUtils qw( slice slice_def );
use Scalar::Util qw( blessed );
use namespace::autoclean;
use LIMS2::Model::Error::Database;
use Try::Tiny;

requires qw( schema check_params throw );

# Internal function, returns a LIMS2::Model::Schema::Result::Plate object
sub _instantiate_plate {
    my ( $self, $params ) = @_;

    if ( blessed( $params ) and $params->isa( 'LIMS2::Model::Schema::Result::Plate' ) ) {
        return $params;
    }
    
    my $validated_params = $self->check_params( { slice( $params, qw( plate_name ) ) }, { plate_name => {} } );
    
    $self->retrieve( Plate => $validated_params );
}

sub pspec_create_plate {
    return {
        plate_name => { validate => 'plate_name' },
        plate_type => { validate => 'existing_plate_type' },
        plate_desc => { validate => 'non_empty_string', optional => 1 },
        created_by => { validate => 'existing_user', post_filter => 'user_id_for' },
        created_at => { validate => 'date_time', optional => 1, post_filter => 'parse_date_time' },
        comments   => { optional => 1 },
        wells      => { optional => 1 }
    }
}

sub pspec_create_plate_comment {
    return {
        plate_comment => { validate => 'non_empty_string' },
        created_by    => { validate => 'existing_user', post_filter => 'user_id_for' },
        created_at    => { validate => 'date_time', optional => 1, post_filter => 'parse_date_time' }
    }
}

sub create_plate {
    my ( $self, $params ) = @_;

    my $validated_params = $self->check_params( $params, $self->pspec_create_plate );
    
    my $plate = $self->schema->resultset( 'Plate' )->create(
        { slice_def( $validated_params, qw( plate_name plate_type plate_desc created_by created_at ) ) }
    );

    for my $c ( @{ $validated_params->{comments} || [] } ) {
        my $validated_c = $self->check_params( $c, $self->pspec_create_plate_comment );
        $plate->create_related( plate_comments => $validated_c );
    }
    
    my $create_well  = sprintf( 'create_%s_well', $validated_params->{plate_type} );

    while ( my ( $well_name, $well_params ) = each %{ $validated_params->{wells} || {} } ) {
        next unless defined $well_params and keys %{$well_params};
        $well_params->{plate_name}   = $validated_params->{plate_name};
        $well_params->{well_name}    = $well_name;
        $well_params->{created_by} ||= $params->{created_by};
        $well_params->{created_at} ||= $params->{created_at};
        $self->$create_well( $well_params, $plate );
    }

    # XXX Should this return profile-specific data?
    return $plate;
}

sub pspec_retrieve_plate {
    return {
        plate_id     => { validate => 'integer', optional => 1 },
        plate_name   => { validate => 'existing_plate_name', optional => 1 },
        profile      => { validate => 'alphanumeric_string', optional => 1, default => 'Default' },
        REQUIRE_SOME => {
            plate_id_or_plate_name => [ 1, qw/plate_name plate_id/ ], # plate_id or plate_name must be specified
        }
    }
}

sub retrieve_plate {
    my ( $self, $params ) = @_;

    my $validated_params = $self->check_params( $params, $self->pspec_retrieve_plate );

    my $profile = delete $validated_params->{profile};

    my $plate = $self->retrieve( Plate => $validated_params );

    my $class = 'LIMS2::Model::Profile::Plate::' . $profile;
    eval "require $class"
        or $self->throw( "Failed to load $class: $@" );

    # The profile class *must* implement as_hash()
    return $class->new( plate => $plate, schema => $self->schema );
}

sub list_plate_types {
    my $self = shift;

    [ $self->schema->resultset( 'PlateType' )->all ];
}

sub pspec_delete_plate {
    return {
        plate_id   => { validate => 'integer', optional => 1 },
        plate_name => { validate => 'plate_name' },
        REQUIRE_SOME => {
            plate_id_or_plate_name => [ 1, qw/plate_name plate_id/ ],
        }
    };
}

sub delete_plate {
    my ( $self, $params ) = @_;

    my $validated_params = $self->check_params( $params, $self->pspec_delete_plate );

    my $plate = $self->schema->resultset( 'Plate' )->find( { plate_name => $validated_params->{plate_name} } );
    $self->throw( 'Plate does not exist: ' . $validated_params->{plate_name} ) unless $plate;

    my @errors;
    foreach my $well ( $plate->wells->all ) {
        try {
            $self->delete_well( $well );
        }
        catch {
            push @errors, $_;
        };
    }

    LIMS2::Model::Error::Database->throw( sprintf "Unable to delete plate %s has following errors:\n%s\n",
        $plate->plate_name, join("\n", sort @errors) ) if @errors;

    $self->log->info('Deleting Plate: ' . $plate->plate_name );
    $plate->plate_comments->delete;
    $plate->delete;
}

1;

__END__
