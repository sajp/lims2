package LIMS2::Model::Plugin::QcSequencingProject;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use Hash::MoreUtils qw( slice slice_def );
use Scalar::Util qw( blessed );
use namespace::autoclean;

requires qw( schema check_params throw );

sub _instantiate_qc_sequencing_project {
    my ( $self, $params ) = @_;

    if ( blessed( $params ) and $params->isa( 'LIMS2::Model::Schema::Result::QcSequencingProject' ) ) {
        return $params;
    }

    my $validated_params = $self->check_params(
        { slice( $params, qw( qc_sequencing_project ) ) },
        { qc_sequencing_project => { validate => 'plate_name', rename => 'name' } }
    );

    $self->retrieve( QcSequencingProject => $validated_params );
}

sub pspec_create_qc_sequencing_project {
    return {
        name => { validate => 'plate_name' },
    };
}

sub create_qc_sequencing_project {
    my ( $self, $params ) = @_;

    my $validated_params = $self->check_params( $params, $self->pspec_create_qc_sequencing_project );

    my $qc_sequencing_project = $self->schema->resultset( 'QcSequencingProject' )->create(
        { slice_def( $validated_params, qw( name ) ) }
    );

    $self->log->debug( 'created qc sequencing project: ' . $qc_sequencing_project->name );

    return $qc_sequencing_project;
}

1;

__END__
