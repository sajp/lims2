package LIMS2::WebApp::Controller::API::QcTemplate;
use Moose;
use namespace::autoclean;

BEGIN {extends 'LIMS2::Catalyst::Controller::REST'; }

=head1 NAME

LIMS2::WebApp::Controller::API::QcTemplate - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub qc_templates :Path( '/api/qc_templates' ) :Args(0) :ActionClass( 'REST' ) { }

=head2 GET /api/qc_templates

Retrieve list of QcTemplate plates

=cut

sub qc_templates_GET {
    my ( $self, $c ) = @_;

    my $qc_templates = $c->model('Golgi')->list(
        QcTemplate => { }, { columns => [ qw( qc_template_id qc_template_name ) ] } );

    $self->status_ok(
        $c,
        entity => { map { $_->qc_template_name => $c->uri_for( '/api/qc_template/'
                        . $_->qc_template_id )->as_string } @{ $qc_templates } },
    );
}

=head2 POST /api/qc_templates

Create a QcTemplate plate along with its wells

=cut

sub qc_templates_POST {
    my ( $self, $c ) = @_;

    $c->assert_user_roles( 'edit' );

    my $qc_template = $c->model( 'Golgi' )->create_qc_template( $c->request->data );

    $self->status_created(
        $c,
        location => $c->uri_for( '/api/qc_template/', $qc_template->qc_template_id ),
        entity   => $qc_template
    );
}

sub qc_template :Path( '/api/qc_template' ) :Args(1) :ActionClass( 'REST' ) { }

=head2 GET /api/qc_template

Retrieve a specific qc_template, by qc_template_id or qc_template_name

=cut

sub qc_template_GET {
    my ( $self, $c, $qc_template ) = @_;

    $c->assert_user_roles( 'read' );

    my $qc_template_params = $qc_template =~ /^\d+$/ ? { qc_template_id => $qc_template }
                                                     : { qc_template_name => $qc_template };

    my $qc_template_obj = $c->model('Golgi')->retrieve_qc_template( $qc_template_params );

    return $self->status_ok(
        $c,
        entity => $qc_template_obj,
    );
}

#TODO: qc template created before certain date

=head1 AUTHOR

Sajith Perera

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
