# ukbrap-ieu-gwas

## Running a GWAS with UKB Genotypes using GCTA fastGWA

### 1. Cohort selection and sample QC
Fields saved in `QCfields.txt`:\
**QC fields:**\
p22001 - gentically inferred sex\
p31 - reported sex\
p22019 - sex chromosome aneuploidy\
p22027 - heterozygosity and missingness rate outliers

**Ancestry restrictions:**\
p21000 - self reported ancestry

**Relatedness:**\
`data.minimal_relateds_81499.plink.txt` - exclude to retain maximum unrelated set of individuals
`data.highly_relateds_81499.plink.txt` - exclude highly related individuals (>200 close <= 3rd degree relatives)

Run:\
`01_pullQCfields.sh` to pull fields from participant data\
`02_writesamplelist.R` (run with `02a_run_writesamplelsit.R` from command line using `dx` or directly with RAP RStudio instance) to generate list of samples to keep

### 2. Create phenotypes/covariate files
Modify `CovariateFields.txt` to replace p50 (height) with required phenotypes in addition to covariates:\
p31 - sex\
p21022 - age at recruitment\
p22000 - genotyping batch\
\+ any fields required for phenotype construction

`ukb22418_v2_merged_EUR_refSNPs_projected_reordered.eigenvec` - common variant principal components generated with `pcapred`

Run:\
`03_pullcovariates.sh` to pull fields from participant data\
`04_makecovariatefiles.R` (modify directly with RAP RStudio instance and `dx upload` to data directory) to generate phenotype and covariate files for GCTA.

### 3. Merging genotype data

### 4. Running model


