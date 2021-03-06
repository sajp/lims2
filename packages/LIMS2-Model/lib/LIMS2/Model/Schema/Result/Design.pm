use utf8;
package LIMS2::Model::Schema::Result::Design;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::Design

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

=head1 TABLE: C<designs>

=cut

__PACKAGE__->table("designs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 created_by

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 design_type

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 phase

  data_type: 'integer'
  is_nullable: 0

=head2 validated_by_annotation

  data_type: 'text'
  is_nullable: 0

=head2 target_transcript

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "created_by",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "created_at",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "design_type",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "phase",
  { data_type => "integer", is_nullable => 0 },
  "validated_by_annotation",
  { data_type => "text", is_nullable => 0 },
  "target_transcript",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 created_by

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "created_by",
  "LIMS2::Model::Schema::Result::User",
  { id => "created_by" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 design_comments

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::DesignComment>

=cut

__PACKAGE__->has_many(
  "design_comments",
  "LIMS2::Model::Schema::Result::DesignComment",
  { "foreign.design_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 design_oligos

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::DesignOligo>

=cut

__PACKAGE__->has_many(
  "design_oligos",
  "LIMS2::Model::Schema::Result::DesignOligo",
  { "foreign.design_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 design_type_rel

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::DesignType>

=cut

__PACKAGE__->belongs_to(
  "design_type_rel",
  "LIMS2::Model::Schema::Result::DesignType",
  { type => "design_type" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 genotyping_primers

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::GenotypingPrimer>

=cut

__PACKAGE__->has_many(
  "genotyping_primers",
  "LIMS2::Model::Schema::Result::GenotypingPrimer",
  { "foreign.design_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 process_cre_bac_recoms

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::ProcessCreBacRecom>

=cut

__PACKAGE__->has_many(
  "process_cre_bac_recoms",
  "LIMS2::Model::Schema::Result::ProcessCreBacRecom",
  { "foreign.design_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 process_create_dis

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::ProcessCreateDi>

=cut

__PACKAGE__->has_many(
  "process_create_dis",
  "LIMS2::Model::Schema::Result::ProcessCreateDi",
  { "foreign.design_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-04-13 11:34:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2swoUvJo6jZnsUz0VLYu1A


# You can replace this text with custom code or comments, and it will be preserved on regeneration

with qw( LIMS2::Model::Schema::Extensions::Design );

__PACKAGE__->meta->make_immutable;
1;
