#!/usr/bin/env Rscript

library(VirFinder)

fasta <- commandArgs(TRUE)[1]
outfile <- commandArgs(TRUE)[2]

predResult <- VF.pred(fasta)

#### Sort sequences by p-value in ascending order
predResult <- predResult[order(predResult$pvalue),]

#### Estimate q-values (false discovery rates) based on p-values.
# pi0.method="bootstrap" to handle issues with the pvalue distributions - EDIT does not work...
# e.g. the error from the qvalue package : "The estimated pi0 <= 0. Check that you have valid p-values or use a different range of lambda."
#predResult$qvalue <- VF.qvalue(predResult$pvalue,pfdr = TRUE)#pi0.meth="bootstrap")

#### Sort sequences by q-value in ascending order
#predResult <- predResult[order(predResult$qvalue),]

#### Write result to file
write.table(x = predResult, file = outfile, sep = "\t", quote = F, row.names = F)