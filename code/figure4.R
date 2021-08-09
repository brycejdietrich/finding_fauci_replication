setwd('/Users/brycedietrich/finding_fauci_replication/')

library(MASS)
library(ggplot2)

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

#create plot data
plot_dat<-rep(0,6)
my_deaths<-c(0,1)
my_healths<-c(0,1)
my_networks<-c('cnn','fox','msnbc')
for(my_network in my_networks){
  for(my_death in my_deaths){
    for(my_health in my_healths){
      temp_pred<-predict(mod1,data.frame(mentions_death2=my_death,mentions_health2=my_health,network2=my_network,cc=median(results[results$network==my_network,'cc'],na.rm=T)),type='response',se.fit=T)$fit
      temp_se<-predict(mod1,data.frame(mentions_death2=my_death,mentions_health2=my_health,network2=my_network,cc=median(results[results$network==my_network,'cc'],na.rm=T)),type='response',se.fit=T)$se.fit
      temp_upper<-temp_pred+1.96*temp_se
      temp_lower<-temp_pred-1.96*temp_se
      temp_row<-c(my_network,my_death,my_health,temp_lower,temp_pred,temp_upper)
      plot_dat<-rbind(plot_dat,temp_row)
    }
  }
}
plot_dat<-data.frame(plot_dat[-1,],stringsAsFactors = F)
names(plot_dat)<-c('Network','Death Mention','Health Mention','lower','fit','upper')
plot_dat$lower<-as.numeric(plot_dat$lower)
plot_dat$fit<-as.numeric(plot_dat$fit)
plot_dat$upper<-as.numeric(plot_dat$upper)
plot_dat$Network<-toupper(plot_dat$Network)
plot_dat$`Death Mention`<-ifelse(plot_dat$`Death Mention`==1,'Yes','No')
plot_dat$`Health Mention`<-ifelse(plot_dat$`Health Mention`==1,'Health Mention = Yes','Health Mention = No')

###cnn plot
plot_dat$Network2<-plot_dat$Network
plot_dat$Network<-factor(plot_dat$Network2,levels=c('MSNBC','CNN','FOX'))

png(filename="output/figure4.png", units = 'px', width=543*20, height=357*20,res=2000)
p<-ggplot(data=plot_dat[plot_dat$Network%in%c('CNN','FOX'),], aes(x=`Death Mention`, y=fit, fill=Network)) +
  geom_bar(stat="identity", position=position_dodge())+
  ylim(c(-0.02,0.29))+
  geom_errorbar(aes(ymin=lower, ymax=upper), width=.2,
                position=position_dodge(.9))+
  ylab('P(Fauci Appearance)')+
  theme_bw()
p <- p + facet_grid(. ~ `Health Mention`)
p
dev.off()
