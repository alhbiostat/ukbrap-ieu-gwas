#!/bin/bash

# Purpose: Apply QC filters to TOPMED imputed data, extract required individuals and save

# This script interacts with the UK Biobank Research Analysis Platform (RAP) via the command line
# using dx-toolkit. To access UKB RAP data and software you must first be logged into the platform
# with <dx-login> and have selected the appropriate project with <dx-select>

# Run:
# run using: ./05_QCgenotypes.sh

# Inputs:

# Output:

# Ensure required input files are uploaded to your files_dir in the RAP space prior to running using:
# dx upload prunesnps.R --path=${scripts_dir}

# ======================================================== #

source ../.env

# NB. if set to all autosomes (i in {1..22}) this will launch 22 independent instances - make sure this is working on one chromosome before doing that!
for i in {22}; do
  run_filter="

  # Copy imputed .bgen format files to instance
  cp /mnt/project/Bulk/Imputation/Imputation\ from\ genotype\ \(TOPmed\)/ukb21007_c${i}_b0_v1.*

  # Pull out required samples
  plink2 --bgen ukb21007_c${i}_b0_v1.bgen ref-first \
  --sample ukb21007_c${i}_b0_v1.sample \
  --keep ukb_unrel_whitebritish_QCed.txt \
  --export bgen-1.2 \
  --out tempfile

  # Extract MAF and INFO calls on subset
  qctool -g tempfile.bgen \
  -s tempfile.sample \
  -snp-stats \
  -osnp snpstats.txt

  # Generate list of SNPs to exclude (outputs snplist_exclude.txt)
  Rscript prunesnps.R snpstats.txt

  # Exclude variants, apply genotyping rate and HWE filter, and convert to pgen format
  plink2 --bgen tempfile.bgen ref-first \
  --sample tempfile.sample \ 
  --set-all-var-ids @:#:\$r:\$a \
  --new-id-max-allele-len 100 missing \
  --exclude snplist_exclude.txt \
  --geno 0.1 \
  --hwe 1e-15 \
  --make-pgen \
  --out ukb_WB_imputed_c${i}_filtered

  # Remove intermediate files
  rm tempfile.*
  rm ukb21007_c${i}_b0_v1.*
  rm snpstats.txt
  rm snplist_exclude.txt
  "

  dx run swiss-army-knife \
  -iin="${script_dir}/prunesnps.R" \
  -iin="${files_dir}/ukb_unrel_whitebritish_QCed.txt" \
  -icmd="${run_filter}" \
  --tag="SNP-filtering-chr${i}" \
  --instance-type="mem2_ssd2_v2_x8" \
	--destination="${project}:${data_dir}/" \
	--brief --yes
done
