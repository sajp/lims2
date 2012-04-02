#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Most;
use LIMS2::Model::DBConnect;
use YAML::Any;

use_ok 'LIMS2::Model';

ok my $schema = LIMS2::Model::DBConnect->connect( 'LIMS2_PROCESS_TEST', 'tests' ),
    'connect to LIMS2_TEST';

ok my $model = LIMS2::Model->new( schema => $schema ), 'instantiate model';

my $params = Load( do { local $/ = undef; <DATA> } );

$model->txn_do(
    sub {
        can_ok $model, 'create_qc_template';

        ok my $qc_template = $model->create_qc_template( $params ), 'create_qc_template should succeed';

        ok my $qc_template_well = $qc_template->qc_template_wells->first, '.. can grab well';

        is $qc_template_well->qc_template_well_name, 'A01', '.. has correct well name';
        is $qc_template_well->eng_seq_method, 'conditional_vector_seq', '.. has correct eng_seq method';

        $model->txn_rollback;
    }
);

done_testing;

__DATA__
---
qc_template_name: VTP00001
wells:
    A01:
        eng_seq_method: conditional_vector_seq
        eng_seq_params: '{"target_region_start":127011877,"five_arm_start":127013739,"three_arm_end":127011800,"five_arm_end":127019673,"transcript":"ENSMUST00000056146","target_region_end":127013636,"three_arm_start":127007813,"backbone":{"name":"R3R4_pBR_DTA+_Bsd_amp","type":"intermediate-backbone"},"u_insertion":{"name":"pR6K_R1R2_ZP","type":"intermediate-cassette"},"chromosome":2,"strand":-1,"d_insertion":{"name":"LoxP","type":"LoxP"}}'
