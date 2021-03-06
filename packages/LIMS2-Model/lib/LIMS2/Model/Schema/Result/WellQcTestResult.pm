use utf8;
package LIMS2::Model::Schema::Result::WellQcTestResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::WellQcTestResult

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

=head1 TABLE: C<well_qc_test_result>

=cut

__PACKAGE__->table("well_qc_test_result");

=head1 ACCESSORS

=head2 well_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 qc_test_result_id

  data_type: 'text'
  is_nullable: 0

=head2 valid_primers

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 pass

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 mixed_reads

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "well_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "qc_test_result_id",
  { data_type => "text", is_nullable => 0 },
  "valid_primers",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "pass",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "mixed_reads",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</well_id>

=back

=cut

__PACKAGE__->set_primary_key("well_id");

=head1 RELATIONS

=head2 well

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::Well>

=cut

__PACKAGE__->belongs_to(
  "well",
  "LIMS2::Model::Schema::Result::Well",
  { well_id => "well_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-01-19 15:28:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SwEVEgxEgmzVG5NXMhu+Gw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
