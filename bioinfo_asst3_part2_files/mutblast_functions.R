# there are some libraries that we need
library("seqinr")
library("rBLAST")

##########################################################
# myblastn is a wrapper for the unix blastn tool
# the input is an R sequence and output is text object
##########################################################
myblastn <- function(myseq,db) {
  mytmpfile1<-tempfile()
  mytmpfile2<-tempfile()
  write.fasta(myseq,names=attr(myseq,"name"),file.out = mytmpfile1)
  system2(command = "/usr/bin/blastn",
          args = paste("-db ", db ," -query", mytmpfile1 ,"-outfmt 1 -evalue 0.05 -ungapped >" 
                       , "tmp"))
  # probably need to add headers here
  res <- NULL
  if (file.info("tmp")$size > 0 ) {
    res <- readLines("tmp")
  }
  #unlink(c(mytmpfile1,mytmpfile2))
  #res <- res[order(-res$bitscore),]
  res
}


##########################################################
# myblastn_tab is a wrapper for the unix blastn tool
# the input is an R sequence and output is tabular object
##########################################################
myblastn_tab <- function(myseq,db) {
  mytmpfile1<-tempfile()
  mytmpfile2<-tempfile()
  write.fasta(myseq,names=attr(myseq,"name"),file.out = mytmpfile1)
  system2(command = "/usr/bin/blastn",
          args = paste("-db ", db ," -query", mytmpfile1 ,"-outfmt 6 -evalue 0.05 -ungapped >" 
          , mytmpfile2))
  # probably need to add headers here
  res <- NULL
  if (file.info(mytmpfile2)$size > 0 ) {
    res <- read.csv(mytmpfile2,sep="\t",header=FALSE)
    colnames(res) <- c("qseqid","sseqid","pident","length","mismatch","gapopen",
      "qstart","qend","sstart","send","evalue","bitscore")
  }
  unlink(c(mytmpfile1,mytmpfile2))
  if (!is.null(res)  ) {
    res <- res[order(-res$bitscore),]
  }
  res
}

##########################################################
# mutator function replaces a number of DNA bases with a random base
##########################################################
mutator <- function(myseq,nmut) {
  myseq_mod <- myseq
  mypos<-sample(seq_along(myseq),nmut)
  myseq_mod[mypos] <- sample(c("a","c","g","t"),length(mypos),replace = TRUE)
  return(myseq_mod)
}