use utf8;
package LIMS2::Model::Schema::Result::BacLibrary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LIMS2::Model::Schema::Result::BacLibrary

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

=head1 TABLE: C<bac_libraries>

=cut

__PACKAGE__->table("bac_libraries");

=head1 ACCESSORS

=head2 library

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("library", { data_type => "text", is_nullable => 0 });

=head1 PRIMARY KEY

=over 4

=item * L</library>

=back

=cut

__PACKAGE__->set_primary_key("library");

=head1 RELATIONS

=head2 bac_clones

Type: has_many

Related object: L<LIMS2::Model::Schema::Result::BacClone>

=cut

__PACKAGE__->has_many(
  "bac_clones",
  "LIMS2::Model::Schema::Result::BacClone",
  { "foreign.library" => "self.library" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-04-13 11:34:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:meQgrh0NdapE7uHz4CEsBA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
