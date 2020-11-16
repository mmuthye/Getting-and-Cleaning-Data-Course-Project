# Assignment Details:
# -------------------
# Here are the data for the project:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# -------------------


# Get the required libraries, define required variables and download and unzip files if not done already
# Read the respective data sets and store them as tables

# Import the dplyr library
library(dplyr)

# Define the URL to the dataset
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Define the filename for the dataset after download
filename <- "UCI HAR Dataset.zip"

# Check if the dataset already exists / downloaded. If not, then download the file 
if (!file.exists(filename)) { 
        download.file(fileURL, filename) 
}
        
# Now check if dataset files already extracted. If not, then unzip the file
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

## Req 4. Appropriately labels the data set with descriptive variable names.
        # Read the various datasets and store them into respective tables
        features <- read.table("UCI HAR Dataset/features.txt", sep="", header=FALSE, col.names = c("n","functions"))
        activities <- read.table("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE, col.names = c("code", "activity")) 

        subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE, col.names = "subject") 
        x_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE, col.names = features$functions) 
        y_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE, col.names = "code") 

        subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE, col.names = "subject") 
        x_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE, col.names = features$functions) 
        y_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE, col.names = "code") 


## Req 1: Merges the training and the test sets to create one data set.

        # Combine the respective training and test data sets
        X <- rbind(x_train, x_test) 
        Y <- rbind(y_train, y_test) 
        Subject <- rbind(subject_train, subject_test) 

        # Now combine them all into a single table
        Merged_Data <- cbind(Subject, X, Y) 


## Req 2: Extracts only the measurements on the mean and standard deviation for each measurement.

        # Extract only mean and standard deviation measurements
        TidyData <- Merged_Data %>% 
                select(subject, code, contains("mean"), contains("std")) 

        # Remove the interim variables from memory that are no longer required
        rm(subject_test)
        rm(subject_train)
        rm(X)
        rm(x_test)
        rm(x_train)
        rm(Y)
        rm(y_test)
        rm(y_train)
        rm(Merged_Data)

## Req 3: Uses descriptive activity names to name the activities in the data set

        #Set the respective activity code
        TidyData$code <- activities[TidyData$code, 2] 

        #Set the appropriate measurements names by replacing the abbreviations or short forms with full names
        names(TidyData)[2] = "activity" 
        names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData)) 
        names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData)) 
        names(TidyData)<-gsub("BodyBody", "Body", names(TidyData)) 
        names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData)) 
        names(TidyData)<-gsub("^t", "Time", names(TidyData)) 
        names(TidyData)<-gsub("^f", "Frequency", names(TidyData)) 
        names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData)) 
        names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE) 
        names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE) 
        names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE) 
        names(TidyData)<-gsub("angle", "Angle", names(TidyData)) 
        names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


## Req 5: Creates an independent tidy data set with the average of each variable for each activity and each subject.
        # Summarize the data
        FinalData <- TidyData %>% 
                group_by(subject, activity) %>% 
                summarise_all(funs(mean)) 
        
        # Write the tidy data set into a new file        
        write.table(FinalData, "FinalTidyData.txt", row.name=FALSE)
        