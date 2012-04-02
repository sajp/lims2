package LIMS2::HTGT::Migrate::PlateData::VTP;

use Moose;
use LIMS2::HTGT::Migrate::Utils;
use namespace::autoclean;

extends 'LIMS2::HTGT::Migrate::PlateData';

has '+plate_type' => (
    default => 'vtp'
);

override well_data => sub {
    my ( $self, $well ) = @_;

    my $data = super();

    $data->{cassette}   = $self->get_htgt_well_data_value( 'cassette' );
    $data->{backbone}   = $self->get_htgt_well_data_value( 'backbone' );


    return $data;
};

__PACKAGE__->meta->make_immutable;

1;

__END__
