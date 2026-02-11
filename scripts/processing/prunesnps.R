# Filter qctools -snp-stats file based on imputation INFO score and MAF
# Variants to exclude:
# Info<0.3 for MAF 3%
# Info<0.6 for MAF 1-3%
# Info<0.8 for MAF 0.5-1%
# Info<0.9 for MAF 0.1-0.5%

# Packages will need to be installed on a new instance
install.packages("data.table")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]

snpstats <- data.table::fread(infile, skip = 9)

out1 <- which(snpstats$minor_allele_frequency >= 0.03 & snpstats$info < 0.3)
out2 <- which(snpstats$minor_allele_frequency >= 0.01 & snpstats$minor_allele_frequency < 0.03 & snpstats$info < 0.6)
out3 <- which(snpstats$minor_allele_frequency >= 0.005 & snpstats$minor_allele_frequency < 0.01 & snpstats$info < 0.8)
out4 <- which(snpstats$minor_allele_frequency >= 0.001 & snpstats$minor_allele_frequency < 0.005 & snpstats$info < 0.9)

message("===== Variants to exclude =====")
message("MAF > 0.03 INFO < 0.3: ", length(out1))
message("MAF 0.01-0.03 INFO < 0.6: ", length(out2))
message("MAF 0.005-0.01 INFO < 0.8: ", length(out3))
message("MAF 0.001-0.005 INFO < 0.9: ", length(out4))

out <- c(out1,out2,out3,out4)
out <- out[order(out)]

snps_out <- snpstats[out,]

message("Total: ", length(out))

# Format for plink2
snpnames <- paste(sub("chr","",snps_out$chromosome),snps_out$position, snps_out$alleleA, snps_out$alleleB, sep = ":")

data.table::fwrite(data.frame(snpnames), "snplist_exclude.txt", col.names = F)
