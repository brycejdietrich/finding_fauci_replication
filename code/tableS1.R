
#### Housekeeping ####
rm(list = ls()) 
setwd('/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/')

library(xtable)

#### Calculate Correlation From STM word data ####
word_prop_data <- read.csv("data/tableS1_worddata.csv") #data is in proportion

##calculate correlation (Health and Keywords)
health_cor <- as.data.frame(cor(word_prop_data[,c(1,4:33)], use = "all.obs", method="pearson")[1,])

##calculate correlation (Death and Keywords)
death_cor <- as.data.frame(cor(word_prop_data[,c(2,4:33)], use = "all.obs", method="pearson")[1,])


#### Create Result File ####

#create column names
names <- c("number", "word1", "word2", "word3", "word4", "word5", "word6", "word7", "health_cor", "death_cor")

#make dataframe for each topic
df_1 <- data.frame("topic 1", "say", "health", "said", "public", "american", "administr", "respons", 
                   round(health_cor[2,], digits =3), round(death_cor[2,], digits =3))
df_2 <- data.frame("topic 2", "now", "right", "time", "come", "well", "take", "back ", 
                   round(health_cor[3,], digits =3), round(death_cor[3,], digits =3))
df_3 <- data.frame("topic 3", "know", "think", "peopl", "want", "dont", "thing", "just", 
                   round(health_cor[4,], digits =3), round(death_cor[4,], digits =3))
df_4 <- data.frame("topic 4", "famili", "offic", "polic", "year", "covid-", "friend", "love", 
                   round(health_cor[5,], digits =3), round(death_cor[5,], digits =3))
df_5 <- data.frame("topic 5", "bill", "senat", "relief", "money", "republican", "democrat", "congree", 
                   round(health_cor[6,], digits =3), round(death_cor[6,], digits =3))
df_6 <- data.frame("topic 6", "may", "risk", "ill", "doctor", "can", "condit", "serious", 
                   round(health_cor[7,], digits =3), round(death_cor[7,], digits =3))
df_7 <- data.frame("topic 7", "biden", "joe", "elect", "vote", "campaign", "trump", "donald", 
                   round(health_cor[8,], digits =3), round(death_cor[8,], digits =3))
df_8 <- data.frame("topic 8", "case", "state", "number", "report", "new", "day", "now",
                   round(health_cor[9,], digits =3), round(death_cor[9,], digits =3))
df_9 <- data.frame("topic 9", "test", "posit", "virus", "contact", "covid-", "quarantine", "day", 
                   round(health_cor[10,], digits =3), round(death_cor[10,], digits =3))
df_10 <- data.frame("topic 10", "hous", "white", "presid", "forc", "coronavirus", "task", "report", 
                    round(health_cor[11,], digits =3), round(death_cor[11,], digits =3))
df_11 <- data.frame("topic 11", "florida", "state", "counti", "california", "text", "south", "weekend", 
                    round(health_cor[12,], digits =3), round(death_cor[12,], digits =3))
df_12 <- data.frame("topic 12", "presid", "trump", "hes", "event", "coronavirus", "ralli", "say", 
                    round(health_cor[13,], digits =3), round(death_cor[13,], digits =3))
df_13 <- data.frame("topic 13", "school", "safe", "children", "kid", "learn", "student", "univers", 
                    round(health_cor[14,], digits =3), round(death_cor[14,], digits =3))
df_14 <- data.frame("topic 14", "thank", "much", "join", "next", "great", "fight", "stori", 
                    round(health_cor[15,], digits =3), round(death_cor[15,], digits =3))
df_15 <- data.frame("topic 15", "get", "see", "look", "that", "even", "still", "happen", 
                    round(health_cor[16,], digits =3), round(death_cor[16,], digits =3))
df_16 <- data.frame("topic 16", "vaccin", "will", "develop", "first", "effect", "approv", "fda", 
                    round(health_cor[17,], digits =3), round(death_cor[17,], digits =3))
df_17 <- data.frame("topic 17", "will", "week", "two", "last", "month", "day", "first",
                    round(health_cor[18,], digits =3), round(death_cor[18,], digits =3))
df_18 <- data.frame("topic 18", "help", "can", "pay", "free", "insur", "stay", "get",
                    round(health_cor[19,], digits =3), round(death_cor[19,], digits =3))
df_19 <- data.frame("topic 19", "virus", "diseas", "doctor", "studi", "drug", "data", "medic", 
                    round(health_cor[20,], digits =3), round(death_cor[20,], digits =3))
df_20 <- data.frame("topic 20", "death", "countri", "coronavirus", "million", "die", "american", "unit", 
                    round(health_cor[24,], digits =3), round(death_cor[21,], digits =3))
df_21 <- data.frame("topic 21", "economi", "job", "year", "crisi", "econom", "america", "coronavirus", 
                    round(health_cor[22,], digits =3), round(death_cor[22,], digits =3))
df_22 <- data.frame("topic 22", "peopl", "mani", "theyr", "countri", "weve", "there", "concern", 
                    round(health_cor[23,], digits =3), round(death_cor[23,], digits =3))
df_23 <- data.frame("topic 23", "need", "make", "work", "can", "care", "everi", "sure", 
                    round(health_cor[24,], digits =3), round(death_cor[24,], digits =3))
df_24 <- data.frame("topic 24", "one", "didnt", "show", "said", "never", "got", "saw", 
                    round(health_cor[25,], digits =3), round(death_cor[25,], digits =3))
df_25 <- data.frame("topic 25", "hand", "use", "food", "power", "check", "store", "eye", 
                    round(health_cor[26,], digits =3), round(death_cor[26,], digits =3))
df_26 <- data.frame("topic 26", "mask", "wear", "peopl", "social", "distanc", "stay", "order", 
                    round(health_cor[27,], digits =3), round(death_cor[27,], digits =3))
df_27 <- data.frame("topic 27", "hospit", "patient", "nurs", "care", "home", "medic", "bed", 
                    round(health_cor[28,], digits =3), round(death_cor[28,], digits =3))
df_28 <- data.frame("topic 28", "news", "good", "morn", "hour", "coronavirus", "tonight", "brea",
                    round(health_cor[31,], digits =3), round(death_cor[29,], digits =3))
df_29 <- data.frame("topic 29", "new", "york", "governor", "citi", "mayor", "state", "coronavirus", 
                    round(health_cor[30,], digits =3), round(death_cor[30,], digits =3))
df_30 <- data.frame("topic 30", "china", "world", "coronavirus", "virus", "organ", "report", "govern", 
                    round(health_cor[31,], digits =3), round(death_cor[31,], digits =3))

#change column names for binding
colnames(df_1) <- names
colnames(df_2) <- names
colnames(df_3) <- names
colnames(df_4) <- names
colnames(df_5) <- names
colnames(df_6) <- names
colnames(df_7) <- names
colnames(df_8) <- names
colnames(df_9) <- names
colnames(df_10) <- names
colnames(df_11) <- names
colnames(df_12) <- names
colnames(df_13) <- names
colnames(df_14) <- names
colnames(df_15) <- names
colnames(df_16) <- names
colnames(df_17) <- names
colnames(df_18) <- names
colnames(df_19) <- names
colnames(df_20) <- names
colnames(df_21) <- names
colnames(df_22) <- names
colnames(df_23) <- names
colnames(df_24) <- names
colnames(df_25) <- names
colnames(df_26) <- names
colnames(df_27) <- names
colnames(df_28) <- names
colnames(df_29) <- names
colnames(df_30) <- names

#make combined dataframe 
combined_df <- rbind(df_1, df_2, df_3, df_4, df_5, df_6, df_7, df_8, df_9, df_10,
                     df_11, df_12, df_13, df_14, df_15, df_16, df_17, df_18, df_19, df_20,
                     df_21, df_22, df_23, df_24, df_25, df_26, df_27, df_28, df_29, df_30)

#export as html
print(xtable(combined_df),type='html',include.rownames=F,file='output/tableS1.html')
