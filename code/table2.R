setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

library(MASS)
library(stargazer)

results<-read.csv('data/final_celebrity_results.csv',as.is=T)

#make fox baseline
results$network2<-factor(results$network,levels=c('fox','cnn','msnbc'))

#set week 9 to zero so the intercept is meaningful
results$week2<-results$week-9

#negative binomial regressions with offsets
mod1<-glm.nb(fauci~network2+offset(log(cc)),data=results)
mod2<-glm.nb(fauci~network2*week2+offset(log(cc)),data=results)

#export table
stargazer(mod1,mod2,intercept.bottom = F,title='Table 2: Dr. Anthony Fauci is Less Likely to Appear on Fox News When the Network is Discussing Covid-19',dep.var.labels=c('Fauci Appearances'),covariate.labels=c('Constant','CNN','MSNBC','Week','CNN X Week','MSNBC X Week'),type='html',out='output/table2.html')

