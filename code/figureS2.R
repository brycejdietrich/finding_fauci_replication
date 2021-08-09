setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

library(MASS)
library(ggplot2)

results<-read.csv('data/final_celebrity_results.csv',as.is=T)

#make fox baseline
results$network2<-factor(results$network,levels=c('fox','cnn','msnbc'))

#set week 9 to zero so the intercept is meaningful
results$week2<-results$week-9

#negative binomial regressions with offsets
mod1<-glm.nb(fauci~network2+offset(log(cc)),data=results)
mod2<-glm.nb(fauci~network2*week2+offset(log(cc)),data=results)

#create confidence intervals around predictions
fox_pred<-predict(mod2,data.frame(network2='fox',week2=min(results$week2):max(results$week2),cc=median(results[results$network=='fox','cc'],na.rm=T)),type='response',se.fit=T)$fit
fox_se<-predict(mod2,data.frame(network2='fox',week2=min(results$week2):max(results$week2),cc=median(results[results$network=='fox','cc'],na.rm=T)),type='response',se.fit=T)$se.fit
fox_upper<-fox_pred+1.96*fox_se
fox_lower<-fox_pred-1.96*fox_se

cnn_pred<-predict(mod2,data.frame(network2='cnn',week2=min(results$week2):max(results$week2),cc=median(results[results$network=='cnn','cc'],na.rm=T)),type='response',se.fit=T)$fit
cnn_se<-predict(mod2,data.frame(network2='cnn',week2=min(results$week2):max(results$week2),cc=median(results[results$network=='cnn','cc'],na.rm=T)),type='response',se.fit=T)$se.fit
cnn_upper<-cnn_pred+1.96*cnn_se
cnn_lower<-cnn_pred-1.96*cnn_se

msnbc_pred<-predict(mod2,data.frame(network2='msnbc',week2=min(results$week2):max(results$week2),cc=median(results[results$network=='msnbc','cc'],na.rm=T)),type='response',se.fit=T)$fit
msnbc_se<-predict(mod2,data.frame(network2='msnbc',week2=min(results$week2):max(results$week2),cc=median(results[results$network=='msnbc','cc'],na.rm=T)),type='response',se.fit=T)$se.fit
msnbc_upper<-msnbc_pred+1.96*msnbc_se
msnbc_lower<-msnbc_pred-1.96*msnbc_se

#create plot data
plot_dat<-data.frame(rbind(cbind('MSNBC',seq(min(results$week2):max(results$week2)),msnbc_lower,msnbc_pred,msnbc_upper),cbind('CNN',seq(min(results$week2):max(results$week2)),cnn_lower,cnn_pred,cnn_upper),cbind('FOX',seq(min(results$week2):max(results$week2)),fox_lower,fox_pred,fox_upper)),stringsAsFactors=F)
names(plot_dat)<-c('Network','week','lower','fit','upper')
plot_dat$fit<-as.numeric(plot_dat$fit)
plot_dat$lower<-as.numeric(plot_dat$lower)
plot_dat$upper<-as.numeric(plot_dat$upper)
plot_dat$week<-as.numeric(plot_dat$week)
plot_dat$Network2<-plot_dat$Network
plot_dat$Network<-factor(plot_dat$Network2,levels=c('MSNBC','CNN','FOX'))

###msnb_fauci plot
png(filename="output/figureS2.png", units = 'px', width=543*20, height=357*20,res=2000)
p <- ggplot(plot_dat[plot_dat$Network%in%c('MSNBC','FOX'),]) + 
  geom_line(aes(y=fit, x=week, colour = Network,linetype=Network))+
  geom_ribbon(aes(ymin=lower, ymax=upper, x=week, fill = Network), alpha = 0.3)+
  ylab('P(Fauci Appearance)')+
  xlab('Week')+
  theme_bw()
p
dev.off()