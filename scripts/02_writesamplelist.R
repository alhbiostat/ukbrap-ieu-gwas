# Generarte list of UKB samples to extract for GWAS
library(data.table)
library(dplyr)

# Read in QC files:
qcfields <- data.table::fread("ukb_QCfields.tsv")
relateds <- data.table::fread("data.minimal_relateds_81499.plink.txt")
highly_relateds <- data.table::fread("data.highly_relateds_81499.plink.txt")

## Retain individuals with matching reported and genetically inferred sex
keepids <- qcfields |> filter(p31 == p22001)

## Exclude heterozygosity/missingness outliers and sex anuploidy samples
keepids <- keepids |> filter(!(p22019 == "Yes"),
                             !(p22027 == "Yes"))

# Retain self reported white British
keepids <- keepids |> filter(p21000_i0 == "British")

# Exclude relateds
relateds_out <- unique(c(highly_relateds$V1, relateds$V1))
keepids <- keepids |> filter(!(eid %in% relateds_out))

nrow(keepids) #354761 IDs to retain

# Write out IDs in plink format
write.table(keepids[,c(1,1)], "ukb_unrel_whitebritish_QCed.txt", row.names = F, col.names = F, quote = F)
