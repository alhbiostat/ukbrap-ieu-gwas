# Purpose: Generate phenotype and covariate files for GCTA fastGWA

library(dplyr)

# Covariates and phenotype fields
fields <- data.table::fread("ukb_covariatefields.tsv")

# PCs
pcs <- data.table::fread("ukb22418_v2_merged_EUR_refSNPs_projected_reordered.eigenvec")

# Samples IDs to retain (based on QC filters)
samples_keep <- data.table::fread("ukb_unrel_whitebritish_QCed.txt")
names(samples_keep) <- c("FID","IID")

## -------------------- .cov files ----------------------- ##
# Catagorical covartiates (sex and batch)
ccovs <- fields |> 
  select(FID = eid, IID = eid, sex = p31, batch = p22000) |>
  mutate(sex = ifelse(sex == "Male",1,2))
## Retain samples to keep and match order
ccovs <- ccovs[match(samples_keep$IID, ccovs$IID),]

# Quantittive covariates (PCs 1-10, age, age^2, age*sex)
qcovs <- fields |>
  select(FID = eid, IID = eid, age = p21022) |>
  mutate(age2 = age^2)
## Retain samples to keep and match order
qcovs <- qcovs[match(samples_keep$IID, qcovs$IID),]
qcovs$agesex <- qcovs$age*ccovs$sex

# Add PCs
qcovs <- qcovs |> left_join(pcs[,c("IID", paste0("PC",1:10))], by = "IID")

## -------------------- .pheno files ----------------------- ##
# Phenotype
phenos <- fields |> select(FID = eid, IID = eid, height = p50_i0) |>
  mutate(height = scale(height))
## Retain samples to keep and match order
phenos <- phenos[match(samples_keep$IID, phenos$IID),]

## -------------------- Remove missing data ----------------------- ##

# Exclude samples missing phenotype and covariate data
samples_out <- unique(
  which(apply(qcovs, 1, function(x){any(is.na(x))})),
  which(apply(ccovs, 1, function(x){any(is.na(x))})),
  which(apply(phenos, 1, function(x){any(is.na(x))})))

ccovs <- ccovs[-samples_out,]
qcovs <- qcovs[-samples_out,]
phenos <- phenos[-samples_out,]

# Write out covaraite and phenotype files
data.table::fwrite(ccovs, "ukb_WB_ccovs.cov", sep = "\t")
data.table::fwrite(qcovs, "ukb_WB_qcovs.cov", sep = "\t")
data.table::fwrite(phenos, "ukb_WB_height.pheno", sep = "\t")

