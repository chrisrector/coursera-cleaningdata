coursera-cleaningdata
=====================

## Repository for classwork relating to the Coursera Getting and Cleaning Data class

This respository contains files that are part of the class project for the Getting and Cleaning Data class. The R code runs on the data provided by this project:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data are motion data collected by 30 subjects via smartphone motion sensors.

run_analysis.R - the R code that processes the motion data to calculate the average of the mean and standard deviation values in the test and training data. It summarizes them by activity (e.g. walking) and subject (identified only by number)

tidymotiondata.txt - the tidy data set created by run_analysis.R. It uses commas to separate values.

CodeBook.md - code book describing the data in tidymotiondata.txt and how it was produced from the original data
