setwd('/Users/brycedietrich/finding_fauci_replication/')

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

#negative binomial regressions with word count offsets
mod1<-glm.nb(health_text~network2+offset(log(wc)),data=results)
mod2<-glm.nb(health_text~network2*week2+offset(log(wc)),data=results)

#export table
stargazer(mod1,mod2,intercept.bottom = F,title="Table 4: Fox News is Significantly Less Likely to Use Words from LIWC's 'Health' Category When Discussing Covid-19",dep.var.labels=c("'Health' Mentions"),covariate.labels=c('Constant','CNN','MSNBC','Week','CNN X Week','MSNBC X Week'),type='html',out='output/table4.html')

