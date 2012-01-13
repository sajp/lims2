package LIMS2::Model::Plugin::Well;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use Hash::MoreUtils qw( slice_def );
use namespace::autoclean;

requires qw( schema check_params throw );

sub pspec_create_well {
    return {
        plate_name          => { validate => 'existing_plate_name' },
        well_name           => { validate => 'well_name' },
        created_by          => { validate => 'existing_user', post_filter => 'user_id_for' },
        created_at          => { validate => 'date_time', optional => 1 },
        assay_started       => { validate => 'date_time', optional => 1 },
        assay_complete      => { validate => 'date_time', optional => 1 },
        distribute          => { validate => 'boolean',   optional => 1 },
        distribute_override => { optional => 1 }
    }
}

sub pspec_create_distribute_override {
    return {
        distribute_override => { validate => 'boolean' },
        created_at          => { validate => 'date_time', optional => 1 },
        created_by          => { validate => 'existing_user', post_filter => 'user_id_for' }
    }
};

# Internal function, returns DBIx::Class::Row object
sub _create_well {
    my ( $self, $plate, $validated_params ) = @_;

    $plate ||= $self->retrieve( Plate => { plate_name => $validated_params->{plate_name} } );
    
    my $well = $plate->create_related(
        well => {
            slice_def( $validated_params, qw( well_name created_by created_at assay_started assay_complete distribute ) )
        }
    );
        
    if ( $validated_params->{distribute_override} ) {
        my $override = $self->check_params( $validated_params->{distribute_override}, $self->pspec_create_distribute_override );
        $well->create_related( well_distribute_override => $override );
    }

    return $well;
}

1;

__END__