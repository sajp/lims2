#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Most;

use_ok 'LIMS2::Model';

ok my $schema = LIMS2::Model::DBConnect->connect( $ENV{LIMS2_DB}, 'tests' ),
    'connect to LIMS2_DB';

ok my $model = LIMS2::Model->new( schema => $schema ), 'instantiate model';

$model->txn_do(
    sub {
        ok my $well = $schema->resultset( 'Well' )->search(
            {
                'process.process_type' => 'cre_bac_recom'
            },
            {
                join     => 'process',
                prefetch => 'plate'
            }
        )->first, 'retrieve Cre/BAC well';
        
        ok my $synvec = $model->retrieve_synthetic_construct( { plate_name => $well->plate->name, well_name => $well->name } ),
            'retrieve_synthetic_construct for Cre/BAC well';
        isa_ok $synvec, 'LIMS2::Model::Schema::Result::SyntheticConstruct';
        $model->txn_rollback;
    }
);

$model->txn_do(
    sub {
        ok my $well = $schema->resultset( 'Well' )->search(
            {
                'process.process_type' => 'int_recom'
            },
            {
                join     => 'process',
                prefetch => 'plate'
            }
        )->first, 'retrieve interemediate recombineering well';

        ok my $synvec = $model->retrieve_synthetic_construct( { plate_name => $well->plate->name , well_name => $well->name } ),
            'retrieve_synthetic_construct for intermediate recombineering well';
        isa_ok $synvec, 'LIMS2::Model::Schema::Result::SyntheticConstruct';
        $model->txn_rollback;
    }
);

done_testing;

