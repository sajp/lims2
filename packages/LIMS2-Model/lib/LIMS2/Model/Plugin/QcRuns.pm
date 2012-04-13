package LIMS2::Model::Plugin::QcRuns;

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use Hash::MoreUtils qw( slice slice_def );
use namespace::autoclean;

requires qw( schema check_params throw );

sub pspec_create_qc_run {
    return {
        id                         => { validate => 'uuid' },
        date                       => { validate => 'date_time', post_filter => 'parse_date_time' },
        profile                    => { validate => 'non_empty_string' },
        software_version           => { validate => 'software_version' },
        qc_sequencing_projects     => { validate => 'non_empty_string' },
        qc_template_name           => { validate => 'plate_name', rename => 'name' },
        qc_template_created_before => { validate => 'date_time', optional => 1, rename => 'created_before' },
    };
}

sub create_qc_run {
    my ( $self, $params ) = @_;
    my $qc_run;

    my $validated_params = $self->check_params( $params, $self->pspec_create_qc_run );

    # TODO: I don't like the rename qc_template_name to name in validate params, rework
    my $qc_template;
    if ( $validated_params->{created_before} ) {
        $qc_template = $self->retrieve_newest_qc_template_created_after(
            { slice( $validated_params
                    , qw( created_before name ) ) }
        );
    }
    else {
        $qc_template = $self->retrieve_qc_template(
            { slice( $validated_params, qw( name ) ) }
        );
    }

    $qc_run = $qc_template->create_related(
        qcs_runs => {
            slice_def( $validated_params,
                       qw( id date profile software_version) )
        }
    );

    my @qc_sequencing_projects = grep { !/^\s*$/ } split ','
        ,$validated_params->{qc_sequencing_projects};
    map { $self->create_qc_run_sequencing_project( { qc_sequencing_project => $_ }, $qc_run ) }
        @qc_sequencing_projects;

    $self->log->debug( 'created qc run : ' . $qc_run->qc_run_id );

    return $qc_run;
}

sub pspec_create_qc_run_sequencing_project {
    return {
        qc_sequencing_project => { validate => 'plate_name' }
    };
}

sub create_qc_run_sequencing_project {
    my ( $self, $params, $qc_run ) = @_;

    my $validated_params = $self->check_params( $params, $self->pspec_create_qc_run_sequencing_project );

    my $qc_run_sequencing_project = $qc_run->create_related(
       qc_run_sequencing_projects => {
           name => $validated_params->{qc_sequencing_project},
       }
    );

    return $qc_run_sequencing_project;
}

sub pspec_retrieve_qc_run {
    return {
        id => { validate => 'uuid' }
    };
}

sub retrieve_qc_run {
    my ( $self, $params ) = @_;

    my $validated_params = $self->check_params( $params, $self->pspec_retrieve_qc_run );

    my $qc_run = $self->retrieve( QcRuns => $validated_params );

    return $qc_run;
}

1;

__END__
