use utf8;
package LIMS2::Model::Schema::Result::WellAssayResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::WellAssayResult

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

=head1 TABLE: C<well_assay_results>

=cut

__PACKAGE__->table("well_assay_results");

=head1 ACCESSORS

=head2 well_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 assay

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 result

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 created_by

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "well_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "assay",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "result",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "created_at",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "created_by",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</well_id>

=item * L</assay>

=back

=cut

__PACKAGE__->set_primary_key("well_id", "assay");

=head1 RELATIONS

=head2 assay_result

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::AssayResult>

=cut

__PACKAGE__->belongs_to(
  "assay_result",
  "LIMS2::Model::Schema::Result::AssayResult",
  { assay => "assay", result => "result" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

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

=head2 well

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::Well>

=cut

__PACKAGE__->belongs_to(
  "well",
  "LIMS2::Model::Schema::Result::Well",
  { id => "well_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-04-13 11:34:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4Z3WXhXBCHeeS3FU2cl6eA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub as_hash {
    my $self = shift;

    return {
        plate_name => $self->well->plate->name,
        well_name  => $self->well->name,
        assay      => $self->assay,
        result     => $self->result,
        created_at => $self->created_at->iso8601,
        created_by => $self->created_by->name
    };
}

__PACKAGE__->meta->make_immutable;
1;
