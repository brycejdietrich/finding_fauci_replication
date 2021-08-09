clear

import delimited "/Users/brycedietrich/finding_fauci_replication/data/tableS3_results.csv", clear 
* NOTE #1: you must have the firthlogit and the estout command. You can install it using:
* ssc install firthlogit, replace
* ssc install estout, replace

sum fauci
recode fauci (0=0) (1/20=1)


label variable fauci "Fauci Appearances"
label variable cnn "CNN"
label variable msnbc "MSNBC"
label variable week2 "Week"
label variable cnn_times_week2 "CNN X Week"
label variable msnbc_times_week2 "MSNBC X Week"


logit fauci cnn msnbc
estat ic
estimates store model1

firthlogit fauci cnn msnbc
estat ic
estimates store model2


logit fauci cnn msnbc week2 cnn_times_week2 msnbc_times_week2
estat ic
estimates store model3

firthlogit fauci cnn msnbc week2 cnn_times_week2 msnbc_times_week2
estat ic
estimates store model4


esttab model1 model2 model3 model4 using "/Users/brycedietrich/finding_fauci_replication/output/tableS3.html", replace ///
	label se(3) b(3) aic scalars(ll) ///
	star(* .1 ** .05 *** .01) ///	
	order(_cons) ///
	varlabels(_cons "Constant") ///
	title ("Table S3: Re-estimating Table 2 Using Logistic Regression") ///
	eqlabel(none) style("html")


estimates clear
