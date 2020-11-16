Getting and Cleaning Data Course Project: Code Book

Input Data
The dataset required for this project is taken from the URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Code Logic
The analysis script, run_analysis.R reads in the processed experiment data and performs the following steps to get it into a tidy summary form.
* Checks if the data set already exists / downloaded. If not, then it downloads it from the given URL
* Checks if the data set is extracted from the zip file. If not, then it extracts it from the zip file.
* The code then reads the respective features and activity labels data sets and stores as tables
* The code then reads the measurement files from train and test data sets and stores as tables for each measurement
* Next step is to combine the train and test data into a single table for each measurement
* Then combine the measurements into a single table with each measurement as a column
* The data columns are then given names based on the features.txt file.
* Only those columns that hold mean or standard deviation measurements are selected from the dataset.
* The data is then grouped by subject and activity, and the average (or mean) is calculated for every measurement column.
* Finally, the summary dataset is written to a file, FinalTidyData.txt.

Output file
The output file is named as . It is a text file with data separated by a single space. The file also contains headers starting with Subject (representing the ID for the experiment participant) and activity (representing the activity that the measurement correspond to). It is then followed by 66 different measurement data points for the given subject for the given activity. The detailed description of the different measurement types can be found in the features_info.txt file which is a part of the UCI HAR Dataset zip file.
