clear

import delimited "/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/data/tableS5_results.csv", clear 
* NOTE #1: you must have the firthlogit and the estout command. You can install it using:
* ssc install firthlogit, replace
* ssc install estout, replace

sum health_text
recode health_text (0=0) (1/921=1)


label variable health_text "Health Mentions"
label variable cnn "CNN"
label variable msnbc "MSNBC"
label variable week2 "Week"
label variable cnn_times_week2 "CNN X Week"
label variable msnbc_times_week2 "MSNBC X Week"


logit health_text cnn msnbc
estat ic
estimates store model1

firthlogit health_text cnn msnbc
estat ic
estimates store model2

logit health_text cnn msnbc week2 cnn_times_week2 msnbc_times_week2
estat ic
estimates store model3

firthlogit health_text cnn msnbc week2 cnn_times_week2 msnbc_times_week2
estat ic
estimates store model4

esttab model1 model2 model3 model4 using "/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/output/tableS5.html", replace ///
	label se(3) b(3) aic scalars(ll) ///
	star(* .1 ** .05 *** .01) ///	
	order(_cons) ///
	varlabels(_cons "Constant") ///
	title ("Table S5: Re-estimating Table 4 Using Logistic Regression") ///
	eqlabel(none) style("html")

estimates clear
