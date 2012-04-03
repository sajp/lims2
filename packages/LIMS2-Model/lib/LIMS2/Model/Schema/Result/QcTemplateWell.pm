use utf8;
package LIMS2::Model::Schema::Result::QcTemplateWell;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::QcTemplateWell

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

=head1 TABLE: C<qc_template_wells>

=cut

__PACKAGE__->table("qc_template_wells");

=head1 ACCESSORS

=head2 qc_template_well_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'qc_template_wells_qc_template_well_id_seq'

=head2 qc_template_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 qc_template_well_name

  data_type: 'text'
  is_nullable: 0

=head2 qc_eng_seq_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "qc_template_well_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "qc_template_wells_qc_template_well_id_seq",
  },
  "qc_template_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "qc_template_well_name",
  { data_type => "text", is_nullable => 0 },
  "qc_eng_seq_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</qc_template_well_id>

=back

=cut

__PACKAGE__->set_primary_key("qc_template_well_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<qc_template_wells_qc_template_id_qc_template_well_name_key>

=over 4

=item * L</qc_template_id>

=item * L</qc_template_well_name>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "qc_template_wells_qc_template_id_qc_template_well_name_key",
  ["qc_template_id", "qc_template_well_name"],
);

=head1 RELATIONS

=head2 qc_eng_seq

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::QcEngSeq>

=cut

__PACKAGE__->belongs_to(
  "qc_eng_seq",
  "LIMS2::Model::Schema::Result::QcEngSeq",
  { qc_eng_seq_id => "qc_eng_seq_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 qc_template

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::QcTemplate>

=cut

__PACKAGE__->belongs_to(
  "qc_template",
  "LIMS2::Model::Schema::Result::QcTemplate",
  { qc_template_id => "qc_template_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-04-03 15:18:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1j1AVBU2/621ENv1XcwjKQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
