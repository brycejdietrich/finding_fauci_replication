#### Housekeeping ####
rm(list = ls()) 
setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

#### Packages ####
library(Dict)
library(readtext)
library(tm)

#### Set up LIWC ####
#load dictionary
liwc_dic_url<-url("https://liwc2007.blob.core.windows.net/liwc2007/LIWC2007_English080730-covid-revise.dic")
liwc_dic<-readLines(liwc_dic_url)
close(liwc_dic_url)

#load categories
liwc_cat_url<-url("https://liwc2007.blob.core.windows.net/liwc2007/LIWC2007_Categories.txt")
liwc_cat<-read.table(liwc_cat_url,col.names=c("num","var"))
liwc_final<-as.list(liwc_cat[,"var"])

##get words
for(i in 1:length(liwc_dic)){
  my_words<-unlist(strsplit(liwc_dic[i],"\t"))	
  for(j in 2:length(my_words)){
    liwc_final[[as.numeric(row.names(liwc_cat[liwc_cat$num==my_words[j],]))]]<-c(as.character(liwc_final[[as.numeric(row.names(liwc_cat[liwc_cat$num==my_words[j],]))]]),my_words[1])
  }
}

##clean words
for(i in 1:length(liwc_final)){
  liwc_final[[i]]<-liwc_final[[i]][-1]
}

##get specific categories
health_words <- unlist(liwc_final[[48]])
work_words <- unlist(liwc_final[[55]])
money_words <- unlist(liwc_final[[59]])
death_words <- unlist(liwc_final[[61]])

#loop through caption files for each cable news
networks <- c('cnn','fox','msnbc')
for(i in 1:length(networks)){
  network <- networks[i]
  input_dir <- paste("data/text/", network, "/", sep="")
  out_dir <- paste("output/text_output/", sep="")
  temp_filelist <- list.files(input_dir)
  temp_output <- data.frame()
  
  for(j in 1:length(temp_filelist)){
    print(paste(network, " ", j, sep = ""))  
    file <- temp_filelist[j]
    temp_transcript <- readtext(paste(input_dir, file, sep = ""))
    names(temp_transcript)[1] <- "file"
    temp_transcript$health_text <- NA
    temp_transcript$work_text <- NA
    temp_transcript$death_text <- NA
    temp_transcript$money_text <- NA
    temp_transcript$wordcounts <- NA
    
    ##get liwc
    my_text <- temp_transcript[1,"text"]
    my_corp <- Corpus(VectorSource(my_text[my_text!="."]))
    
    #convert to lowercase
    my_corp <- tm_map(my_corp,tolower)
    
    #remove "stop" words like an, the, etc.
    my_corp <- tm_map(my_corp,removeWords,stopwords("english"))
    
    #remove punctuation
    my_corp <- tm_map(my_corp,removePunctuation)
    
    #remove numbers
    my_corp <- tm_map(my_corp,removeNumbers)
    
    #eliminate whitespace
    my_corp <- tm_map(my_corp,stripWhitespace)
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)
    my_corp <- tm_map(my_corp,trim)
    
    #record results
    temp_transcript[1,"health_text"] <- sum(unlist(sapply(health_words,function(x){return(lengths(grep(glob2rx(x),unlist(strsplit(my_corp[[1]]$content," ")))))},USE.NAMES=FALSE)))
    temp_transcript[1,"work_text"] <- sum(unlist(sapply(work_words,function(x){return(length(grep(glob2rx(x),unlist(strsplit(my_corp[[1]]$content," ")))))},USE.NAMES=FALSE)))
    temp_transcript[1,"death_text"] <- sum(unlist(sapply(death_words,function(x){return(length(grep(glob2rx(x),unlist(strsplit(my_corp[[1]]$content," ")))))},USE.NAMES=FALSE)))
    temp_transcript[1,"money_text"] <- sum(unlist(sapply(money_words,function(x){return(length(grep(glob2rx(x),unlist(strsplit(my_corp[[1]]$content," ")))))},USE.NAMES=FALSE)))
    temp_transcript[1,"wordcounts"] <- length(unlist(strsplit(my_corp[[1]]$content," ")))    
    
    temp_output <- rbind(temp_output, temp_transcript)
  }
  write.csv(temp_output, paste(out_dir, network, '_word', '.csv', sep=""),row.names=FALSE)
}
