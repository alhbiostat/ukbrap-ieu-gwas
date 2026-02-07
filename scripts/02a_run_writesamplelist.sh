#!/bin/bash

# Purpose: Call 02_writesamplelist.R to write out list of unrelated white British samples to keep for GWAS

# This script interacts with the UK Biobank Research Analysis Platform (RAP) via the command line
# using dx-toolkit. To access UKB RAP data and software you must first be logged into the platform
# with <dx-login> and have selected the appropriate project with <dx-select>

# Run:
# run using: ./02a_pullQCfields.sh

# Inputs:
# ukb_QCfields
# data.minimal_relateds_81499.plink.txt
# data.minimal_relateds_81499.plink.txt

# Output:
# ukb_unrel_whitebritish_QCed.txt

# Ensure required input files and scripts are uploaded to your files_dir and scripts_dir in the RAP space prior to running using:
# dx upload 02a_run_writesamplelist.R --path=${scripts_dir}

# ======================================================== #

source ../.env

run_rscript="
# Call R script for sample filtering
Rscript 02_writesamplelist.R
"

dx run swiss-army-knife \
	-iin="${files_dir}/ukb_QCfields.tsv" \
  -iin="${files_dir}/data.minimal_relateds_81499.plink.txt" \
  -iin="${files_dir}/data.highly_relateds_81499.plink.txt" \
	-iin="${script_dir}/02_writesamplelist.R" \
	-icmd="${run_rscript}" \
	--tag="write sample list" \
	--instance-type="mem1_ssd1_v2_x4" \
	--destination="${project}:${files_dir}/" \
	--brief --yes --allow-ssh