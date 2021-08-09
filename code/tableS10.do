clear

import delimited using "/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/data/tableS10_results.csv"

* NOTE #1: you must have the estout command. You can install it using:
* ssc install estout, replace


label variable fauci "Fauci Appearances"

label variable cnn "CNN"

label variable msnbc "MSNBC"

label variable cnn_times_death "CNN X 'Death' Mentions"

label variable cnn_times_health "CNN X 'Health' Mentions"

label variable msnbc_times_death "MSNBC X 'Death' Mentions"

label variable msnbc_times_health "MSNBC X 'Health' Mentions"

label variable death_times_health "'Death' Mentions X 'Health' Mentions"

label variable cnn_times_death_and_health "CNN X 'Death' Mentions X 'Health' Mentions"

label variable msnbc_times_death_and_health "MSNBC X 'Death' Mentions X 'Health' Mentions"

nbreg fauci cnn msnbc mentions_death2 mentions_health2 cnn_times_death cnn_times_health msnbc_times_death msnbc_times_health death_times_health cnn_times_death_and_health msnbc_times_death_and_health, offset(log_cc) cluster(show_id)

estimates store model1

esttab model1 using "/Users/brycedietrich/Research_Group Dropbox/bryce dietrich/dietrich_ko_replication/output/tableS10.html", replace ///
	label se(3) b(3) aic scalars(ll) ///
	star(* .1 ** .05 *** .01) ///	
	order(_cons) ///
	varlabels(_cons "Constant") ///	
	title ("Table S10: Table 5 Re-estimated in STATA with Standard Errors Clustered at the Show-Level") ///
	eqlabel(none) style("html")

estimates clear
