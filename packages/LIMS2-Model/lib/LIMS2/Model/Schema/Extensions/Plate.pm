package LIMS2::Model::Schema::Extensions::Plate;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use namespace::autoclean;

with qw( MooseX::Log::Log4perl );

sub as_hash {
    my $self = shift;

    return {
        name        => $self->name,
        plate_type  => $self->plate_type,
        description => $self->description,
        created_at  => $self->created_at->iso8601,
        created_by  => $self->created_by->name,
        comments    => [ map { $_->as_hash } $self->plate_comments ]
    };
}

1;

__END__
