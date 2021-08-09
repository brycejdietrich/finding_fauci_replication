clear

import delimited "/Users/brycedietrich/finding_fauci_replication/data/tableS6_results.csv", clear 
* NOTE #1: you must have the firthlogit and the estout command. You can install it using:
* ssc install firthlogit, replace
* ssc install estout, replace

sum fauci
recode fauci (0=0) (1/20=1)


label variable fauci	"Fauci Appearances"
label variable cnn	"CNN"
label variable msnbc	"MSNBC"
label variable mentions_death2	"'Death' Mentions"
label variable mentions_health2 "'Health' Mentions"
label variable cnn_times_death	"CNN X 'Death' Mentions"
label variable cnn_times_health	"CNN X 'Health' Mentions"
label variable msnbc_times_death	"MSNBC X 'Death' Mentions"
label variable msnbc_times_health	"MSNBC X 'Health' Mentions"
label variable death_times_health	"'Death' Mentions X 'Health' Mentions"
label variable cnn_times_death_and_health	"CNN X 'Death' Mentions X 'Health' Mentions"
label variable msnbc_times_death_and_health	"MSNBC X 'Death' Mentions X 'Health' Mentions"


logit fauci cnn msnbc mentions_death2 mentions_health2 cnn_times_death cnn_times_health msnbc_times_death msnbc_times_health death_times_health cnn_times_death_and_health msnbc_times_death_and_health
estat ic
estimates store model1

firthlogit fauci cnn msnbc mentions_death2 mentions_health2 cnn_times_death cnn_times_health msnbc_times_death msnbc_times_health death_times_health cnn_times_death_and_health msnbc_times_death_and_health
estat ic
estimates store model2

esttab model1 model2 using "/Users/brycedietrich/finding_fauci_replication/output/tableS6.html", replace ///
	label se(3) b(3) aic scalars(ll) ///
	star(* .1 ** .05 *** .01) ///	
	order(_cons) ///
	varlabels(_cons "Constant") ///
	title ("Table S6: Re-estimating Table 5 Using Logistic Regression") ///
	eqlabel(none) style("html")

estimates clear

