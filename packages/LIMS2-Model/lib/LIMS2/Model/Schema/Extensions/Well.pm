package LIMS2::Model::Schema::Extensions::Well;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use namespace::autoclean;

sub is_accepted {
    my $self = shift;

    if ( my $o = $self->well_accepted_override ) {
        return $o->accepted;
    }

    return $self->accepted;
}

sub as_hash {
    my $self = shift;

    return {
        plate_name     => $self->plate->plate_name,
        well_name      => $self->well_name,
        created_by     => $self->created_by->user_name,
        created_at     => $self->created_at->iso8601,
        assay_pending  => $self->assay_pending  ? $self->assay_pending->iso8601  : '',
        assay_complete => $self->assay_complete ? $self->assay_complete->iso8601 : '',
        accepted       => $self->is_accepted,
    };
}

1;

__END__
