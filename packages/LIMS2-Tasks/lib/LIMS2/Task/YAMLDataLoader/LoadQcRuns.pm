package LIMS2::Task::YAMLDataLoader::LoadQcRuns;
use strict;
use warnings FATAL => 'all';

use Moose;
use LIMS2::Util::YAMLIterator;
use List::MoreUtils qw( all );
use namespace::autoclean;

extends 'LIMS2::Task::YAMLDataLoader';

override abstract => sub {
    'Load QcRun data from YAML file';
};

override create => sub {
    my ( $self, $datum ) = @_;

    $self->model->create_qc_run( $datum );
};

override record_key => sub {
    my ( $self, $datum ) = @_;

    return $datum->{qc_run_id} || '<undef>';
};

override wanted => sub {
    my ( $self, $datum ) = @_;

    my $qc_run = $self->schema->resultset( 'QcRuns' )->find( { id => $datum->{qc_run_id} } );
    if ( $qc_run ) {
        $self->log->warn( "Skipping existing qc run $datum->{qc_run_id}" );
        return 0;
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;

1;

__END__
