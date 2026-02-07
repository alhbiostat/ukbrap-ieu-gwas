# ukbrap-ieu-gwas

## Running a GWAS with UKB Genotypes

### 1. Cohort selection and sample QC
**QC fields:**\
p22001 - inferred gender\
p31 - reported gender\
p22019 - sex chromosome aneuploidy\
p22027 - heterozygosity and missingness rate outliers

**Ancestry restrictions:**\
p21000 - self reported ancestry

**Relatedness:**\
`data.minimal_relateds_81499.plink.txt` - exclude to retain maximum unrelated set of individuals
`data.highly_relateds_81499.plink.txt` - exclude highly related individuals (>200 close <= 3rd degree relatives)

Run:\
`01_pullQCfields.sh` to pull fields from participant data\
`02_writesamplelist.R` (run with `02a_run_writesamplelsit.R`) to generate list of samples to keep\

### 2. Extracting phenotypes/covariates

### 3. Merging genotype data

### 4. Running model


