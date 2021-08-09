setwd('/Users/brycedietrich/finding_fauci_replication/')

library(MASS)
library(stargazer)

#re-estimate table 2
image_results<-read.csv('data/final_celebrity_results.csv',as.is=T)

#make fox baseline
image_results$network2<-factor(image_results$network,levels=c('fox','cnn','msnbc'))

#set week 9 to zero so the intercept is meaningful
image_results$week2<-image_results$week-9

#negative binomial regressions with offsets
mod1<-glm.nb(fauci~network2+offset(log(cc)),data=image_results)
mod2<-glm.nb(fauci~network2*week2+offset(log(cc)),data=image_results)

#subset image data to only include complete cases
image_results<-image_results[names(residuals(mod2)),]

#create ID
image_results$id<-paste(image_results$show,image_results$week,image_results$year,sep='_')

#load text restuls and create ID
text_results<-read.csv('data/final_caption_results.csv',as.is=T)
text_results$id<-paste(text_results$show,text_results$week,text_results$year,sep='_')

#merge results
results<-merge(image_results,text_results[,c('id','death_text','health_text')])

#set week 9 to zero so the intercept is meaningful
results$week2<-results$week-9

#make fox baseline
results$network2<-factor(results$network,levels=c('fox','cnn','msnbc'))

#create binary variable discussed on page 13 in the main text
my_shows<-unique(results$show)
for(my_show in my_shows){
  results[results$show==my_show,'mentions_health2']<-ifelse(results[results$show==my_show,'health_text']>median(results[results$show==my_show,'health_text'],na.rm=T),1,0)
  results[results$show==my_show,'mentions_death2']<-ifelse(results[results$show==my_show,'death_text']>median(results[results$show==my_show,'death_text'],na.rm=T),1,0)
}

#estimate negative binomial regression with offset
mod1<-glm.nb(fauci~network2*mentions_death2*mentions_health2+offset(log(cc)),data=results)

#export table
stargazer(mod1,intercept.bottom = F,order=c(1,2,3,4,5,6,8,7,9,10,11,12),title="Table 5: Are Dr. Anthony Fauci's Appearances Condidtioned on the Text?",dep.var.labels=c('Fauci Appearances'),covariate.labels=c('Constant','CNN','MSNBC',"'Death' Mentions","'Health' Mentions","CNN X 'Death' Mentions","CNN X 'Health' Mentions","MSNBC X 'Death' Mentions","MSNBC X 'Health' Mentions","'Death' Mentions X 'Health' Mentions","CNN X 'Death' Mentions X 'Health' Mentions","MSNBC X 'Death' Mentions X 'Health' Mentions"),type='html',out='output/table5.html')
