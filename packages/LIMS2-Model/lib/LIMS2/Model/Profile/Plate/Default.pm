package LIMS2::Model::Profile::Plate::Default;
use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

extends qw( LIMS2::Model::Profile::Plate );

__PACKAGE__->meta->make_immutable;

1;
