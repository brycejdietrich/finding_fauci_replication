setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

library(MASS)
library(stargazer)

results<-read.csv('data/final_caption_results.csv',as.is=T)

#make fox baseline
results$network2<-factor(results$network,levels=c('fox','cnn','msnbc'))

#set week 9 to zero so the intercept is meaningful
results$week2<-results$week-9

#we have 3 more weeks of text data than image data, so to make results 
#comparable we are going to restrict text data to week 9 or greater
results<-results[results$week2>=0,]

#only want to use closed captioning where we captured some text
results$wc<-results$wordcounts
results<-results[results$wc>0,]

#load atlas and fauci counts
counts<-read.csv('data/atlas_and_fauci_counts.csv',as.is=T)

#create IDs
counts$id<-paste(counts$show,counts$week,counts$year,sep='_')
results$id<-paste(results$show,results$week,results$year,sep='_')

#merge results
results<-merge(results,counts[,c('id','atlas_text','fauci_text')])

#create atlas and fauci proportions
results$atlas_prop<-results$atlas_text/results$wc
results$fauci_prop<-results$fauci_text/results$wc

#estimate OLS regressions
mod1<-lm(I(atlas_prop-fauci_prop)~network2,data=results)
mod2<-lm(I(atlas_prop-fauci_prop)~network2*week2,data=results)

#export table
stargazer(mod1,mod2,intercept.bottom = F,title="Table S2: Dr. Atlas is More Likely to Be Referenced on Fox News When Covid-19 is Discussed",dep.var.labels=c("Atlas Proportion - Fauci Proportion"),covariate.labels=c('Constant','CNN','MSNBC','Week','CNN X Week','MSNBC X Week'),omit.stat=c('f','ser'),type='html',out='output/tableS2.html')
