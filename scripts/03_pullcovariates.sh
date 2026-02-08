#!/bin/bash

# Purpose: Extract covariant and phenotype fields for UKB participants based on list of field names

# This script interacts with the UK Biobank Research Analysis Platform (RAP) via the command line
# using dx-toolkit. To access UKB RAP data and software you must first be logged into the platform
# with <dx-login> and have selected the appropriate project with <dx-select>

# Run:
# run using: ./03_pullcovaraites.sh

# Inputs:
# CovariateFields.txt (List of field IDs)

# Output:
# ukb_covariatefields.tsv

# Ensure required input files are uploaded to your files_dir in the RAP space prior to running using:
# dx upload CovariateFields.txt --path=${files_dir}

# ======================================================== #

source ../.env

dx run table-exporter \
	-idataset_or_cohort_or_dashboard="${dataset}" \
	-ioutput="ukb_covariatefields" \
	-ioutput_format="TSV" \
	-icoding_option="REPLACE" \
	-iheader_style="FIELD-NAME" \
	-ientity="participant" \
	-ifield_names_file_txt="${files_dir}/CovariateFields.txt" \
	--instance-type "mem1_ssd1_v2_x4" \
	--destination="${project}:${files_dir}/" \
	--priority="high" \
	--brief --yes