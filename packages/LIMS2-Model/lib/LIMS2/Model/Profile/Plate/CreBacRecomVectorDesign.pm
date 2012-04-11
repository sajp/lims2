package LIMS2::Model::Profile::Plate::CreBacRecomVectorDesign;
use Moose;
use MooseX::ClassAttribute;
use Hash::MoreUtils qw( slice_def );
use namespace::autoclean;

extends qw( LIMS2::Model::Profile::Plate );

class_has '+well_data_fields' => (
    default => sub {
        return [ qw(
            well_name
            marker_symbol
            chromosome
            strand
            ensembl_gene_id
            bac_name
            chr_start
            chr_end
            bac_length
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

    my $cre_bac_process_data = $cre_bac_recom_process->as_hash;
    my $design               = $cre_bac_recom_process->design->as_hash;
    my %data = (
        slice_def( $cre_bac_process_data, qw( design_id bac_name chr_start chr_end ) ),
        slice_def( $design, qw( marker_symbol ensembl_gene_id chromosome strand ) ),
        bac_length => $cre_bac_process_data->{chr_end} - $cre_bac_process_data->{chr_start},
        %{ $well_data },
    );

    return \%data;
};

__PACKAGE__->meta->make_immutable;

1;
