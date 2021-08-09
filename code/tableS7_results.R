setwd('/Users/brycedietrich/finding_fauci_replication/')

library(MASS)
library(stargazer)

#this code creates the tableS7_results file.

results<-read.csv('data/final_celebrity_results.csv',as.is=T)

#make fox baseline
results$network2<-factor(results$network,levels=c('fox','cnn','msnbc'))

#set week 9 to zero so the intercept is meaningful
results$week2<-results$week-9

#negative binomial regressions with offsets
mod1<-glm.nb(fauci~network2+offset(log(cc)),data=results)
mod2<-glm.nb(fauci~network2*week2+offset(log(cc)),data=results)

#create smaller dataset with only complete cases
stata_results<-results[names(residuals(mod2)),]

#create network dummy variables
stata_results$cnn<-ifelse(stata_results$network=='cnn',1,0)
stata_results$msnbc<-ifelse(stata_results$network=='msnbc',1,0)

#create logged variable for offset
stata_results$log_cc<-log(stata_results$cc)

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
write.csv(stata_results,'data/tableS7_results.csv',row.names=F)

