use utf8;
package LIMS2::Model::Schema::Result::GenotypingPrimer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::GenotypingPrimer

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

=head1 TABLE: C<genotyping_primers>

=cut

__PACKAGE__->table("genotyping_primers");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'genotyping_primers_id_seq'

=head2 type

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 design_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 seq

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "genotyping_primers_id_seq",
  },
  "type",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "design_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "seq",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 design

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::Design>

=cut

__PACKAGE__->belongs_to(
  "design",
  "LIMS2::Model::Schema::Result::Design",
  { id => "design_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 genotyping_primer_type_rel

Type: belongs_to

Related object: L<LIMS2::Model::Schema::Result::GenotypingPrimerType>

=cut

__PACKAGE__->belongs_to(
  "genotyping_primer_type_rel",
  "LIMS2::Model::Schema::Result::GenotypingPrimerType",
  { type => "type" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-04-13 12:59:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2hQNQU1hjvhlYPfd6CLKug


# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub as_hash {
    my $self = shift;

    return {
        type => $self->type,
        seq  => $self->seq
    };
}

__PACKAGE__->meta->make_immutable;
1;
