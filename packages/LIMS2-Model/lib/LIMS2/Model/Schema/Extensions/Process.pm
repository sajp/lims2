package LIMS2::Model::Schema::Extensions::Process;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use LIMS2::Model::Error::Database;
use namespace::autoclean;

sub get_process {
    my $self = shift;

    my $type = $self->process_type;
    my $process_type = 'process_' . $type;

    return $self->$process_type;
}

1;

__END__
