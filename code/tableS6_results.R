setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

library(MASS)
library(stargazer)

#this code creates the tableS6_results file.

image_results<-read.csv('data/final_celebrity_results.csv',as.is=T)
image_results$network2<-factor(image_results$network,levels=c('fox','cnn','msnbc'))
image_results$week2<-image_results$week-9
mod1<-glm.nb(fauci~network2+offset(log(cc)),data=image_results)
mod2<-glm.nb(fauci~network2*week2+offset(log(cc)),data=image_results)
image_results<-image_results[names(residuals(mod2)),]
image_results$id<-paste(image_results$show,image_results$week,image_results$year,sep='_')
text_results<-read.csv('data/final_caption_results.csv',as.is=T)
text_results$id<-paste(text_results$show,text_results$week,text_results$year,sep='_')
results<-merge(image_results,text_results[,c('id','death_text','health_text')])
results$week2<-results$week-9
results$network2<-factor(results$network,levels=c('fox','cnn','msnbc'))

#create binary variable discussed on page 13 in the main text
my_shows<-unique(results$show)
for(my_show in my_shows){
  results[results$show==my_show,'mentions_health2']<-ifelse(results[results$show==my_show,'health_text']>median(results[results$show==my_show,'health_text'],na.rm=T),1,0)
  results[results$show==my_show,'mentions_death2']<-ifelse(results[results$show==my_show,'death_text']>median(results[results$show==my_show,'death_text'],na.rm=T),1,0)
}

#estimate negative binomial regression with offset
mod1<-glm.nb(fauci~network2*mentions_death2*mentions_health2+offset(log(cc)),data=results)

#create everything needed for stata
stata_results<-results[names(residuals(mod1)),]
stata_results$cnn<-ifelse(stata_results$network=='cnn',1,0)
stata_results$msnbc<-ifelse(stata_results$network=='msnbc',1,0)
stata_results$log_cc<-log(stata_results$cc)
stata_results$cnn_times_death<-stata_results$cnn*stata_results$mentions_death2
stata_results$cnn_times_health<-stata_results$cnn*stata_results$mentions_health2
stata_results$msnbc_times_death<-stata_results$msnbc*stata_results$mentions_death2
stata_results$msnbc_times_health<-stata_results$msnbc*stata_results$mentions_health2
stata_results$death_times_health<-stata_results$mentions_death2*stata_results$mentions_health2
stata_results$cnn_times_death_and_health<-stata_results$cnn*stata_results$mentions_death2*stata_results$mentions_health2
stata_results$msnbc_times_death_and_health<-stata_results$msnbc*stata_results$mentions_death2*stata_results$mentions_health2

my_shows<-unique(stata_results$show)
my_shows<-my_shows[-1]
stata_results$show_id<-0
for(i in 1:length(my_shows)){
  stata_results[stata_results$show==my_shows[i],'show_id']<-i
}

#save table S6_results
write.csv(stata_results,'data/tableS6_results.csv',row.names=F)

