#!/bin/bash
#$ -cwd
#$ -jc long
#$ -N ImputeGenotypes
#$ -pe smp 1
#$ -adds l_hard h_vmem 6G
#$ -adds l_hard m_mem_free 6G
#$ -M 2395453@dundee.ac.uk
#$ -m beas

# These are needed modules in UT HPC to get Singularity and Nextflow running.
# Replace with appropriate ones for your HPC.
# module load java-1.8.0_40
# module load singularity/3.5.3
# module load squashfs/4.4

# If you follow the eQTLGen phase II cookbook and analysis folder structure,
# some of the following paths are pre-filled.
# https://github.com/eQTLGen/eQTLGen-phase-2-cookbook/wiki/eQTLGen-phase-II-cookbook

# We set the following variables for nextflow to prevent writing to your home directory (and potentially filling it completely)
# Feel free to change these as you wish.
export SINGULARITY_CACHEDIR=../../singularitycache
export NXF_HOME=../../nextflowcache

# Define paths and arguments
nextflow_path=../../tools # folder where Nextflow executable is.
reference_path=../hg38 # folder where you unpacked the reference files.

cohort_name="GAIT2_RNAseq"
qc_input_folder=../../1_DataQC/output/ # folder with QCd genotype and expression data, output of DataQC pipeline.
output_path=../output/ # Output path.
genome_build="GRCh37"

# Command
NXF_VER=21.10.6 ${nextflow_path}/nextflow run eQTLGenImpute.nf \
--qcdata ${qc_input_folder} \
--target_ref ${reference_path}/genome_reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
--ref_panel_hg38 ${reference_path}/harmonizing_reference/30x-GRCh38_NoSamplesSorted \
--eagle_genetic_map ${reference_path}/phasing_reference/genetic_map/genetic_map_hg38_withX.txt.gz \
--eagle_phasing_reference ${reference_path}/phasing_reference/phasing/ \
--minimac_imputation_reference ${reference_path}/imputation_reference/ \
--cohort_name ${cohort_name} \
--genome_build ${genome_build} \
--outdir ${output_path}  \
-profile sge,singularity \
-resume
