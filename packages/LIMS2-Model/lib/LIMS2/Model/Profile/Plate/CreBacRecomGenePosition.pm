package LIMS2::Model::Profile::Plate::CreBacRecomGenePosition;
use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

extends qw( LIMS2::Model::Profile::Plate );

class_has '+well_data_fields' => (
    default => sub {
        return [ qw(
            well_name
            marker_symbol
            bac_id
            design_id
        ) ];
    }
);

override 'get_well_data' => sub {
    my ( $self, $well ) = @_;
    my $well_data = super();

    my $process = $well->process;
    my $cre_bac_recom_process = $self->get_process_of_type( $process, 'cre_bac_recom' );
    return $well_data unless $cre_bac_recom_process;

    $well_data->{bac_id}        = $cre_bac_recom_process->bac_name;
    $well_data->{marker_symbol} = $cre_bac_recom_process->design->marker_symbol;
    $well_data->{design_id}     = $cre_bac_recom_process->design->design_id;

    return $well_data;
};

__PACKAGE__->meta->make_immutable;

1;
