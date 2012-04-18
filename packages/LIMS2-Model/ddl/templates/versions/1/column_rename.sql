-- Users
ALTER TABLE users RENAME COLUMN user_id to id;
ALTER TABLE users RENAME COLUMN user_name to name;

ALTER TABLE roles RENAME COLUMN role_id to id;
ALTER TABLE roles RENAME COLUMN role_name to name;

-- Genes
ALTER TABLE ensembl_gene_data RENAME COLUMN ensembl_gene_id to id;
ALTER TABLE ensembl_gene_data RENAME COLUMN ensembl_gene_chromosome to chromosome;
ALTER TABLE ensembl_gene_data RENAME COLUMN ensembl_gene_start to chr_start;
ALTER TABLE ensembl_gene_data RENAME COLUMN ensembl_gene_end to chr_end;
ALTER TABLE ensembl_gene_data RENAME COLUMN ensembl_gene_strand to strand;

ALTER TABLE vega_gene_data RENAME COLUMN vega_gene_id to id;
ALTER TABLE vega_gene_data RENAME COLUMN vega_gene_chromosome to chromosome;
ALTER TABLE vega_gene_data RENAME COLUMN vega_gene_start to chr_start;
ALTER TABLE vega_gene_data RENAME COLUMN vega_gene_end to chr_end;
ALTER TABLE vega_gene_data RENAME COLUMN vega_gene_strand to strand;

ALTER TABLE genes RENAME COLUMN gene_id to id;

ALTER TABLE gene_comments RENAME COLUMN gene_comment_id to id;
ALTER TABLE gene_comments RENAME COLUMN gene_comment to comment;

-- Bac data
ALTER TABLE bac_libraries RENAME COLUMN bac_library to library;

ALTER TABLE bac_clones RENAME COLUMN bac_name to name;
ALTER TABLE bac_clones RENAME COLUMN bac_library to library;

ALTER TABLE bac_clone_loci RENAME COLUMN bac_name to name;
ALTER TABLE bac_clone_loci RENAME COLUMN bac_library to library;

-- Design data
ALTER TABLE design_types RENAME COLUMN design_type to type;

ALTER TABLE designs RENAME COLUMN design_id to id;
ALTER TABLE designs RENAME COLUMN design_name to name;

ALTER TABLE design_oligo_types RENAME COLUMN design_oligo_type to type;

ALTER TABLE design_oligos RENAME COLUMN design_oligo_seq to seq;

ALTER TABLE design_comment_categories RENAME COLUMN design_comment_category_id to id;
ALTER TABLE design_comment_categories RENAME COLUMN design_comment_category to category;

ALTER TABLE design_comments RENAME COLUMN design_comment_id to id;
ALTER TABLE design_comments RENAME COLUMN design_comment to comment;

ALTER TABLE genotyping_primer_types RENAME COLUMN genotyping_primer_type to type;

ALTER TABLE genotyping_primers RENAME COLUMN genotyping_primer_id to id;
ALTER TABLE genotyping_primers RENAME COLUMN genotyping_primer_type to type;
ALTER TABLE genotyping_primers RENAME COLUMN genotyping_primer_seq to seq;

-- Pipelines and projects
ALTER TABLE pipelines RENAME COLUMN pipeline_id to id;
ALTER TABLE pipelines RENAME COLUMN pipeline_name to name;
ALTER TABLE pipelines RENAME COLUMN pipeline_desc to description;

-- Data applicable to all plates
ALTER TABLE plate_types RENAME COLUMN plate_type to type;
ALTER TABLE plate_types RENAME COLUMN plate_type_desc to description;

ALTER TABLE plates RENAME COLUMN plate_id to id;
ALTER TABLE plates RENAME COLUMN plate_name to name;
ALTER TABLE plates RENAME COLUMN plate_desc to description;

ALTER TABLE plate_comments RENAME COLUMN plate_comment_id to id;
ALTER TABLE plate_comments RENAME COLUMN plate_comment to comment;

-- Processes (define before wells so well can have FK to process)
ALTER TABLE process_types RENAME COLUMN process_type to type;
ALTER TABLE process_types RENAME COLUMN process_description to description;

ALTER TABLE processes RENAME COLUMN process_id to id;

-- Data applicable to all wells
ALTER TABLE wells RENAME COLUMN well_id to id;
ALTER TABLE wells RENAME COLUMN well_name to name;

-- Data for sequencing QC
ALTER TABLE synthetic_constructs RENAME COLUMN synthetic_construct_id to id;
ALTER TABLE synthetic_constructs RENAME COLUMN synthetic_construct_genbank to genbank;

ALTER TABLE qc_templates RENAME COLUMN qc_template_id to id;
ALTER TABLE qc_templates RENAME COLUMN qc_template_name to name;
ALTER TABLE qc_templates RENAME COLUMN qc_template_created_at to created_at;

ALTER TABLE qc_template_wells RENAME COLUMN qc_template_well_id to id;
ALTER TABLE qc_template_wells RENAME COLUMN qc_template_well_name to name;

ALTER TABLE qc_eng_seqs RENAME COLUMN qc_eng_seq_id to id;

ALTER TABLE qc_runs RENAME COLUMN qc_run_id to id;
ALTER TABLE qc_runs RENAME COLUMN qc_run_date to date;

ALTER TABLE qc_seq_reads RENAME COLUMN qc_seq_read_id to id;

ALTER TABLE qc_sequencing_projects RENAME COLUMN qc_sequencing_project to name;

ALTER TABLE qc_test_results RENAME COLUMN qc_test_result_id to id;

ALTER TABLE qc_test_result_alignments RENAME COLUMN qc_test_result_alignment_id to id;

ALTER TABLE qc_test_result_align_regions RENAME COLUMN qc_test_result_alignment_id to id;

ALTER SEQUENCE design_comment_categories_design_comment_category_id_seq RENAME TO design_comment_categories_id_seq;
ALTER SEQUENCE design_comments_design_comment_id_seq RENAME TO design_comments_id_seq;
ALTER SEQUENCE gene_comments_gene_comment_id_seq RENAME TO gene_comments_id_seq;
ALTER SEQUENCE genes_gene_id_seq RENAME TO genes_id_seq;
ALTER SEQUENCE genotyping_primers_genotyping_primer_id_seq RENAME TO genotyping_primers_id_seq;
ALTER SEQUENCE pipelines_pipeline_id_seq RENAME TO pipelines_id_seq;
ALTER SEQUENCE plate_comments_plate_comment_id_seq RENAME TO plate_comments_id_seq;
ALTER SEQUENCE plates_plate_id_seq RENAME TO plates_id_seq;
ALTER SEQUENCE processes_process_id_seq RENAME TO processes_id_seq;
ALTER SEQUENCE qc_eng_seqs_qc_eng_seq_id_seq RENAME TO qc_eng_seqs_id_seq;
ALTER SEQUENCE qc_template_wells_qc_template_well_id_seq RENAME TO qc_template_wells_id_seq;
ALTER SEQUENCE qc_templates_qc_template_id_seq RENAME TO qc_templates_id_seq;
ALTER SEQUENCE qc_test_result_alignments_qc_test_result_alignment_id_seq RENAME TO qc_test_result_alignments_id_seq;
ALTER SEQUENCE qc_test_results_qc_test_result_id_seq RENAME TO qc_test_results_id_seq;
ALTER SEQUENCE roles_role_id_seq RENAME TO roles_id_seq;
ALTER SEQUENCE synthetic_constructs_synthetic_construct_id_seq RENAME TO synthetic_constructs_id_seq;
ALTER SEQUENCE users_user_id_seq RENAME TO users_id_seq;
ALTER SEQUENCE wells_well_id_seq RENAME TO wells_id_seq;
