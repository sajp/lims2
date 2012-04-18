-- Users
ALTER TABLE audit.users RENAME COLUMN user_id to id;
ALTER TABLE audit.users RENAME COLUMN user_name to name;

ALTER TABLE audit.roles RENAME COLUMN role_id to id;
ALTER TABLE audit.roles RENAME COLUMN role_name to name;

-- Genes
ALTER TABLE audit.ensembl_gene_data RENAME COLUMN ensembl_gene_id to id;
ALTER TABLE audit.ensembl_gene_data RENAME COLUMN ensembl_gene_chromosome to chromosome;
ALTER TABLE audit.ensembl_gene_data RENAME COLUMN ensembl_gene_start to chr_start;
ALTER TABLE audit.ensembl_gene_data RENAME COLUMN ensembl_gene_end to chr_end;
ALTER TABLE audit.ensembl_gene_data RENAME COLUMN ensembl_gene_strand to strand;

ALTER TABLE audit.vega_gene_data RENAME COLUMN vega_gene_id to id;
ALTER TABLE audit.vega_gene_data RENAME COLUMN vega_gene_chromosome to chromosome;
ALTER TABLE audit.vega_gene_data RENAME COLUMN vega_gene_start to chr_start;
ALTER TABLE audit.vega_gene_data RENAME COLUMN vega_gene_end to chr_end;
ALTER TABLE audit.vega_gene_data RENAME COLUMN vega_gene_strand to strand;

ALTER TABLE audit.genes RENAME COLUMN gene_id to id;

ALTER TABLE audit.gene_comments RENAME COLUMN gene_comment_id to id;
ALTER TABLE audit.gene_comments RENAME COLUMN gene_comment to comment;

-- Bac data
ALTER TABLE audit.bac_libraries RENAME COLUMN bac_library to library;

ALTER TABLE audit.bac_clones RENAME COLUMN bac_name to name;
ALTER TABLE audit.bac_clones RENAME COLUMN bac_library to library;

ALTER TABLE audit.bac_clone_loci RENAME COLUMN bac_name to name;
ALTER TABLE audit.bac_clone_loci RENAME COLUMN bac_library to library;

-- Design data
ALTER TABLE audit.design_types RENAME COLUMN design_type to type;

ALTER TABLE audit.designs RENAME COLUMN design_id to id;
ALTER TABLE audit.designs RENAME COLUMN design_name to name;

ALTER TABLE audit.design_oligo_types RENAME COLUMN design_oligo_type to type;

ALTER TABLE audit.design_oligos RENAME COLUMN design_oligo_seq to seq;

ALTER TABLE audit.design_comment_categories RENAME COLUMN design_comment_category_id to id;
ALTER TABLE audit.design_comment_categories RENAME COLUMN design_comment_category to category;

ALTER TABLE audit.design_comments RENAME COLUMN design_comment_id to id;
ALTER TABLE audit.design_comments RENAME COLUMN design_comment to comment;

ALTER TABLE audit.genotyping_primer_types RENAME COLUMN genotyping_primer_type to type;

ALTER TABLE audit.genotyping_primers RENAME COLUMN genotyping_primer_id to id;
ALTER TABLE audit.genotyping_primers RENAME COLUMN genotyping_primer_type to type;
ALTER TABLE audit.genotyping_primers RENAME COLUMN genotyping_primer_seq to seq;

-- Pipelines and projects
ALTER TABLE audit.pipelines RENAME COLUMN pipeline_id to id;
ALTER TABLE audit.pipelines RENAME COLUMN pipeline_name to name;
ALTER TABLE audit.pipelines RENAME COLUMN pipeline_desc to description;

-- Data applicable to all plates
ALTER TABLE audit.plate_types RENAME COLUMN plate_type to type;
ALTER TABLE audit.plate_types RENAME COLUMN plate_type_desc to description;

ALTER TABLE audit.plates RENAME COLUMN plate_id to id;
ALTER TABLE audit.plates RENAME COLUMN plate_name to name;
ALTER TABLE audit.plates RENAME COLUMN plate_desc to description;

ALTER TABLE audit.plate_comments RENAME COLUMN plate_comment_id to id;
ALTER TABLE audit.plate_comments RENAME COLUMN plate_comment to comment;

-- Processes (define before wells so well can have FK to process)
ALTER TABLE audit.process_types RENAME COLUMN process_type to type;
ALTER TABLE audit.process_types RENAME COLUMN process_description to description;

ALTER TABLE audit.processes RENAME COLUMN process_id to id;

-- Data applicable to all wells
ALTER TABLE audit.wells RENAME COLUMN well_id to id;
ALTER TABLE audit.wells RENAME COLUMN well_name to name;

-- Data for sequencing QC
ALTER TABLE audit.synthetic_constructs RENAME COLUMN synthetic_construct_id to id;
ALTER TABLE audit.synthetic_constructs RENAME COLUMN synthetic_construct_genbank to genbank;

ALTER TABLE audit.qc_templates RENAME COLUMN qc_template_id to id;
ALTER TABLE audit.qc_templates RENAME COLUMN qc_template_name to name;
ALTER TABLE audit.qc_templates RENAME COLUMN qc_template_created_at to created_at;

ALTER TABLE audit.qc_template_wells RENAME COLUMN qc_template_well_id to id;
ALTER TABLE audit.qc_template_wells RENAME COLUMN qc_template_well_name to name;

ALTER TABLE audit.qc_eng_seqs RENAME COLUMN qc_eng_seq_id to id;

ALTER TABLE audit.qc_runs RENAME COLUMN qc_run_id to id;
ALTER TABLE audit.qc_runs RENAME COLUMN qc_run_date to date;

ALTER TABLE audit.qc_seq_reads RENAME COLUMN qc_seq_read_id to id;

ALTER TABLE audit.qc_sequencing_projects RENAME COLUMN qc_sequencing_project to name;

ALTER TABLE audit.qc_test_results RENAME COLUMN qc_test_result_id to id;

ALTER TABLE audit.qc_test_result_alignments RENAME COLUMN qc_test_result_alignment_id to id;

ALTER TABLE audit.qc_test_result_align_regions RENAME COLUMN qc_test_result_alignment_id to id;
