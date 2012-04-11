package LIMS2::Model::Profile::Plate::Design;
use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

extends qw( LIMS2::Model::Profile::Plate );

class_has '+well_data_fields' => (
    default => sub {
        my $self = shift;

        my @well_data_fields = qw(
            well_name
            pipeline
            design_id
            design_type
            legacy_qc_results
            assay_pending
            assay_complete
            accepted
        );

        return [ @well_data_fields, @{ $self->assay_result_fields } ];
    }
);

override 'get_well_data' => sub {
    my ( $self, $well ) = @_;
    my $well_data = super();

    my $process = $well->process;
    my $create_di_process = $self->get_process_of_type( $process, 'create_di' );
    return $well_data unless $create_di_process;

    my $design                = $create_di_process->design;
    $well_data->{design_id}   = $design->design_id;
    $well_data->{design_type} = $design->design_type;

    $well_data->{legacy_qc_results} = $self->get_legacy_qc_results( $well );
    my $assay_results               = $self->get_well_assay_results( $well );
    map{ $well_data->{$_} = $assay_results->{$_} if exists $assay_results->{$_} }
        @{ $self->assay_result_fields };

    return $well_data;
};


__PACKAGE__->meta->make_immutable;

1;
