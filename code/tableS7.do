clear

import delimited using "/Users/brycedietrich/finding_fauci_replication/data/tableS7_results.csv"

* NOTE #1: you must have the estout command. You can install it using:
* ssc install estout, replace

label variable fauci "Fauci Appearances"

label variable cnn "CNN"

label variable msnbc "MSNBC"

label variable week2 "Week"

label variable cnn_times_week2 "CNN X Week"

label variable msnbc_times_week2 "MSNBC X Week"

nbreg fauci cnn msnbc, offset(log_cc) cluster(show_id)

estimates store model1

nbreg fauci cnn msnbc week2 cnn_times_week2 msnbc_times_week2, offset(log_cc) cluster(show_id)

estimates store model2

esttab model1 model2 using "/Users/brycedietrich/finding_fauci_replication/output/tableS7.html", replace ///
	label se(3) b(3) aic scalars(ll) ///
	star(* .1 ** .05 *** .01) ///	
	order(_cons) ///
	varlabels(_cons "Constant") ///
	title ("Table S7: Table 3 Re-estimated in STATA with Standard Errors Clustered at the Show-Level") ///
	eqlabel(none) style("html")

estimates clear
