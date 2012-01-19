use utf8;
package LIMS2::Model::Schema::Result::Well;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::Well

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<wells>

=cut

__PACKAGE__->table("wells");

=head1 ACCESSORS

=head2 well_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'wells_well_id_seq'

=head2 plate_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 well_name

  data_type: 'char'
  is_nullable: 0
  size: 3

=head2 created_by

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 assay_pending

  data_type: 'timestamp'
  is_nullable: 1

=head2 assay_complete

  data_type: 'timestamp'
  is_nullable: 1

=head2 accepted

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "well_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "wells_well_id_seq",
  },
  "plate_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "well_name",
  { data_type => "char", is_nullable => 0, size => 3 },
  "created_by",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "created_at",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "assay_pending",
  { data_type => "timestamp", is_nullable => 1 },
  "assay_complete",
  { data_type => "timestamp", is_nullable => 1 },
  "accepted",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</well_id>

=back

=cut

__PACKAGE__->set_primary_key("well_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<wells_plate_id_well_name_key>

=over 4

=item * L</plate_id>

=item * L</well_name>

=back

=cut

__PACKAGE__->add_unique_constraint("wells_plate_id_well_name_key", ["plate_id", "well_name"]);

=head1 RELATIONS

=head2 created_by

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "created_by",
  "LIMS2::Model::Schema::Result::User",
  { user_id => "created_by" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 design_well_bacs

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::DesignWellBac>

=cut

__PACKAGE__->has_many(
  "design_well_bacs",
  "LIMS2::Model::Schema::Result::DesignWellBac",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 design_well_design

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::DesignWellDesign>

=cut

__PACKAGE__->might_have(
  "design_well_design",
  "LIMS2::Model::Schema::Result::DesignWellDesign",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 plate

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::Plate>

=cut

__PACKAGE__->belongs_to(
  "plate",
  "LIMS2::Model::Schema::Result::Plate",
  { plate_id => "plate_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 tree_paths_ancestors

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::TreePath>

=cut

__PACKAGE__->has_many(
  "tree_paths_ancestors",
  "LIMS2::Model::Schema::Result::TreePath",
  { "foreign.ancestor" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tree_paths_descendants

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::TreePath>

=cut

__PACKAGE__->has_many(
  "tree_paths_descendants",
  "LIMS2::Model::Schema::Result::TreePath",
  { "foreign.descendant" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_accepted_override

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::WellAcceptedOverride>

=cut

__PACKAGE__->might_have(
  "well_accepted_override",
  "LIMS2::Model::Schema::Result::WellAcceptedOverride",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_assay_results

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::WellAssayResult>

=cut

__PACKAGE__->has_many(
  "well_assay_results",
  "LIMS2::Model::Schema::Result::WellAssayResult",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_backbone

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::WellBackbone>

=cut

__PACKAGE__->might_have(
  "well_backbone",
  "LIMS2::Model::Schema::Result::WellBackbone",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_cassette

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::WellCassette>

=cut

__PACKAGE__->might_have(
  "well_cassette",
  "LIMS2::Model::Schema::Result::WellCassette",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_clone_name

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::WellCloneName>

=cut

__PACKAGE__->might_have(
  "well_clone_name",
  "LIMS2::Model::Schema::Result::WellCloneName",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_legacy_qc_test_result

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::WellLegacyQcTestResult>

=cut

__PACKAGE__->might_have(
  "well_legacy_qc_test_result",
  "LIMS2::Model::Schema::Result::WellLegacyQcTestResult",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 well_qc_test_result

Type: might_have

Related object: L<LIMS2::Model::Schema::Result::WellQcTestResult>

=cut

__PACKAGE__->might_have(
  "well_qc_test_result",
  "LIMS2::Model::Schema::Result::WellQcTestResult",
  { "foreign.well_id" => "self.well_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-01-19 15:28:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cd+NE3CYnzI5T+wP1Giphw


# You can replace this text with custom code or comments, and it will be preserved on regeneration

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
        assay_pending  => $self->assay_pending ? $self->assay_pending->iso8601 : '',
        assay_complete => $self->assay_complete ? $self->assay_complete->iso8601 : '',
        accepted       => $self->is_accepted
    };
}

__PACKAGE__->meta->make_immutable;
1;
