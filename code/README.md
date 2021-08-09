# This folder contains all the code necessary to replicate the figures/tables in the main text and Appendix of "Finding Fauci."

Requires all data in the "data" folder. Also, "sample_word_count.R" and "sample-microsoft-celebrity-api.py" provide examples of how our image and text variables were created. The former uses the text files in the "text" subfolder in the aforementioned "data" directory. The latter uses the "images" subfolder. However, the celebrity api code requires users to upload images to Microsoft's servers and register an API key, so it is not runnable in its present form. Assuming these are added, the code should produce the contents of the "image_output" subdirectory in the "output" folder. The "sample_word_count" code can be run and should produce the output in the "text_output" subdirectory from the same output folder.