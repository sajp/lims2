package LIMS2::Model::FormValidator::Constraint;

use strict;
use warnings FATAL => 'all';

use DateTime::Format::ISO8601;
use Regexp::Common;
use Try::Tiny;

sub in_set {

    my $values;

    if ( @_ == 1 and ref $_[0] eq 'ARRAY' ) {
        $values = $_[0];
    }
    else {
        $values = \@_;
    }    
    
    my %is_in_set = map { $_ => 1 } @{$values};

    return sub {
        $is_in_set{ shift() }
    };
}

sub in_resultset {
    my ( $model, $resultset_name, $column_name ) = @_;
    in_set( [ map { $_->$column_name } $model->schema->resultset( $resultset_name )->all ] );
}

sub regexp_matches {
    my $match = shift;
    return sub {
        shift =~ m/$match/;
    };
}

sub date_time {
    return sub {
        my $str = shift;
        try {
            DateTime::Format::ISO8601->parse_datetime( $str );
        };
    };    
}

sub strand {
    in_set( 1, -1 );
}

sub phase {
    in_set( 0, 1, 2 );
}

sub boolean {
    in_set( 0, 1 );
}

sub validated_by_annotation {
    in_set( 'yes', 'no', 'maybe' );
}

sub dna_seq {
    regexp_matches( qr/^[ATGC]+$/ );
}

sub user_name {
    regexp_matches( qr/^\w+[\w\@\.\-\:]+$/ );
}

sub integer {
    regexp_matches( $RE{num}{int} );
}

sub alphanumeric_string {
    regexp_matches( qr/^\w+$/ );
}

sub non_empty_string {
    regexp_matches( qr/\S+/ );
}

sub bac_library {
    regexp_matches( qr/^\w+$/ );
}

sub bac_name {
    regexp_matches( qr/^[\w()-]+$/ );
}

sub existing_assembly {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'Assembly', 'assembly' );
}

sub existing_bac_library {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'BacLibrary', 'bac_library' );
}

sub existing_chromosome {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'Chromosome', 'chromosome' );
}

sub existing_design_type {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'DesignType', 'design_type' );
}

sub existing_design_comment_category {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'DesignCommentCategory', 'design_comment_category' );
}

sub existing_design_oligo_type {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'DesignOligoType', 'design_oligo_type' );
}

sub existing_genotyping_primer_type {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'GenotpyingPrimerType', 'genotyping_primer_type' );
}

sub existing_user {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'User', 'user_name' );
}

sub existing_role {
    my ( $class, $model ) = @_;    
    in_resultset( $model, 'Role', 'role_name' );
}

1;

__END__