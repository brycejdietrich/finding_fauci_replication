clear

import delimited "/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/data/tableS4_results.csv", clear 
* NOTE #1: you must have the firthlogit and the estout command. You can install it using:
* ssc install firthlogit, replace
* ssc install estout, replace

sum death_text
recode death_text (0=0) (1/331=1)


label variable death_text "Death Mentions"
label variable cnn "CNN"
label variable msnbc "MSNBC"
label variable week2 "Week"
label variable cnn_times_week2 "CNN X Week"
label variable msnbc_times_week2 "MSNBC X Week"


logit death_text cnn msnbc
estat ic
estimates store model1

firthlogit death_text cnn msnbc
estat ic
estimates store model2


logit death_text cnn msnbc week2 cnn_times_week2 msnbc_times_week2
estat ic
estimates store model3

firthlogit death_text cnn msnbc week2 cnn_times_week2 msnbc_times_week2
estat ic
estimates store model4


esttab model1 model2 model3 model4 using "/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/output/tableS4.html", replace ///
	label se(3) b(3) aic scalars(ll) ///
	star(* .1 ** .05 *** .01) ///	
	order(_cons) ///
	varlabels(_cons "Constant") ///
	title ("Table S4: Re-estimating Table 3 Using Logistic Regression") ///
	eqlabel(none) style("html")

estimates clear
