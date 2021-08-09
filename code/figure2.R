## Set directory ##
setwd('/Users/brycedietrich/finding_fauci_replication/')

## Packages ##
require(ggplot2)
require(patchwork)

## Load Data ##
word_plotdata <- read.csv("data/figure2_words_data.csv", header=TRUE)
fauci_plotdata <- read.csv("data/figure2_fauci_data.csv", header=TRUE)

## Draw Plot ##
health_plot <- ggplot(word_plotdata, aes(x=month, y=prop_health, fill = network)) +
  geom_bar(stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_errorbar(aes(ymin = low95ci_prop_health, ymax = up95ci_prop_health),
                width = 0.2, position = position_dodge(0.9)) +
  theme_bw() + 
  labs(x="Month", y="Proportion of Health Words") +
  scale_x_continuous(breaks = c(2,3,4,5,6,7,8,9,10,11,12),
                     labels = paste0(c("Feb", "Mar", "Apr", "May", "Jun",
                                       "Jul", "Aug", "Sep", "Oct", "Nov",
                                       "Dec")))

death_plot <- ggplot(word_plotdata, aes(x=month, y=prop_death, fill = network)) +
  geom_bar(stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_errorbar(aes(ymin = low95ci_prop_death, ymax = up95ci_prop_death),
                width = 0.2, position = position_dodge(0.9))+
  theme_bw() + 
  labs(x="Month", y="Proportion of Death Words") +
  scale_x_continuous(breaks = c(2,3,4,5,6,7,8,9,10,11,12),
                     labels = paste0(c("Feb", "Mar", "Apr", "May", "Jun",
                                       "Jul", "Aug", "Sep", "Oct", "Nov",
                                       "Dec")))  

fauci_plot <- ggplot(fauci_plotdata, aes(x=month, y=prop_fauci, fill = network)) +
  geom_bar(stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_errorbar(aes(ymin = low95ci_prop_fauci, ymax = up95ci_prop_fauci),
                width = 0.2, position = position_dodge(0.9)) +
  theme_bw() + 
  labs(x="Month", y="Proportion of Fauci Appearance") +
  scale_x_continuous(breaks = c(2,3,4,5,6,7,8,9,10,11,12),
                     labels = paste0(c("Feb", "Mar", "Apr", "May", "Jun",
                                       "Jul", "Aug", "Sep", "Oct", "Nov",
                                       "Dec")))

png(filename="output/figure2.png", width=676*20, height=670*20, res=2000)
p <- health_plot / death_plot / fauci_plot
p
dev.off()