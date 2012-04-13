package LIMS2::Model::Profile::Plate::PCS;
use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

extends qw( LIMS2::Model::Profile::Plate );

class_has '+well_data_fields' => (
    default => sub {
        my $self = shift;

        my @well_data_fields = qw(
            name
            pipeline
            cassette
            backbone
            design_id
            design_type
            design_well
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
    my $int_recom_process = $self->get_process_of_type( $process, 'int_recom' );
    return $well_data unless $int_recom_process;

    my $design_well = $int_recom_process->design_well;
    my $design = $design_well->process->process_create_di->design;
    $well_data->{design_id}   = $design->id;
    $well_data->{design_type} = $design->design_type;
    $well_data->{design_well} = "$design_well";
    $well_data->{cassette}    = $int_recom_process->cassette;
    $well_data->{backbone}    = $int_recom_process->backbone;

    $well_data->{assay_results}     = $self->get_well_assay_results( $well );
    $well_data->{legacy_qc_results} = $self->get_legacy_qc_results( $well );

    return $well_data;
};

__PACKAGE__->meta->make_immutable;

1;
