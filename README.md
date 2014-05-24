GCDProject
==========

This project for done the the Getting and Cleaning Data (GCD) course from Johns Hopkins University, Bloomberg School of Public health.

The author was Richard Werezak Copyright (c)2014.  The date was FRI23MAY2014.

The data for this project was obtained from:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The citation is:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This project contains the following files:
                             
* README.md
* FilesToUseDiagram.png
* GCDProject_UCIHARTidyData.txt
* GCDProject_UCIHARTidyData_Averages.txt
* CodeBook.md
* run_analysis.R
* UCI HAR Dataset.zip

The tidy datafiles can be obtained by ruuning the R script 'run_analysis.R' via the command:

   R --save < run_analysis.R

Various diagnostic output is shown on the screen and saved to the workspace.

This will create the two files:

* GCDProject_UCIHARTidyData.txt: the tidy dataset which was to be produced for the project
* GCDProject_UCIHARTidyData_Averages.txt: this analysis of the data per subject per activity

It was unclear which file needed to be uploaded.  I uploaded the second one (i.e. the one with averages).

The ZIP file must be in the project directory.

The codebook for the first file is located in the file 'CodeBook.md'.

The diagram wa created by TA David Hook.  I included it because it very clearly describes how the tidy data file was created.
