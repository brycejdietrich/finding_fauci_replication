setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

library(MASS)

#this code creates the tableS9_results file.

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

#negative binomial regressions with word count offsets
mod1<-glm.nb(health_text~network2+offset(log(wc)),data=results)
mod2<-glm.nb(health_text~network2*week2+offset(log(wc)),data=results)

#create smaller dataset with only complete cases
stata_results<-results[names(residuals(mod2)),]

#create network dummy variables
stata_results$cnn<-ifelse(stata_results$network=='cnn',1,0)
stata_results$msnbc<-ifelse(stata_results$network=='msnbc',1,0)

#create logged variable for offset
stata_results$log_wc<-log(stata_results$wc)

#create dummy variables for interaction terms
stata_results$cnn_times_week2<-stata_results$cnn*stata_results$week2
stata_results$msnbc_times_week2<-stata_results$msnbc*stata_results$week2

#create numeric show ids
my_shows<-unique(stata_results$show)
my_shows<-my_shows[-1]
stata_results$show_id<-0
for(i in 1:length(my_shows)){
  stata_results[stata_results$show==my_shows[i],'show_id']<-i
}

#save table S7_results
write.csv(stata_results,'data/tableS9_results.csv',row.names=F)
