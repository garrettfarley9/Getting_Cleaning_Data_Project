#### Read in data. ####
#Libraries
rm(list=ls())
library(dplyr)
library(readr)
library(tibble)

#Date and time opened by Sys.time
opened<-"2020-05-05 14:35:36 CDT"

#Data set
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Read in features file using readr
features<- read_delim("UCI HAR Dataset/features.txt", col_names = FALSE, delim = " ")

#Read in test files using readr
sub_test<-read_table("UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)
testy<- read_table("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
testx<-read_table("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)

#Read in train files using readr
sub_train<-read_table("UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)
trainy<-read_table("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
trainx<-read_table("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)

#### Step 4. Appropriately labels the data set with descriptive variable names. ####
#Rename variables for activity and participant
names(sub_test)[names(sub_test)=="X1"] <- "participant_id"
names(testy)[names(testy)=="X1"]<-"activity_id"

#Use features to rename testx variables
for(i in 1:561) {
        x <- paste("X", i, sep = "")
        names(testx)[names(testx) == x]<-as.character(features$X2[i])
}

#Rename variables for activity and participant
names(sub_train)[names(sub_train)=="X1"] <- "participant_id"
names(trainy)[names(trainy)=="X1"]<-"activity_id"

#Use features to rename trainx variables
for(i in 1:561) {
        x <- paste("X", i, sep = "")
        names(trainx)[names(trainx) == x]<-as.character(features$X2[i])
}
#### Step 1. Merges the training and the test sets to create one data set. ####
#Use dplyr to bind test and train variables
test<-bind_cols(sub_test, testy, testx)
train<-bind_cols(sub_train, trainy, trainx)

#Remove unused tables
rm(features, sub_test, testx, testy, sub_train, trainx, trainy)

#Use dplyr to bind test and train tables
total_set<-bind_rows(test, train)

#Remove unused tables
rm(test, train)

#### Step 3. Uses descriptive activity names to name the activities in the data set. ####
#Read in activity labels
activity<-read_table("UCI HAR Dataset/activity_labels.txt", col_names = FALSE)

#Use activity labels as named factors
total_set$activity_id <- factor(total_set$activity_id, 
                                levels = activity$X1, labels = activity$X2)
#Remove unused data sets
rm(activity)

#### Step 2. Extracts only the mean and standard deviation for each measurement. ####
mean_std_data<-select(total_set, participant_id, 
                 activity_id, contains("mean()") | contains("std()"))

#### Step 5. Create independent tidy data set of the average of each variable, each activity, each subject. ####
#Get the means for each variable by participant and activity
summarized<-group_by(mean_std_data, participant_id, activity_id)%>%
        summarise_all(mean)

#Write file
write.table(summarized, file = "wearable_averages.txt", row.names = FALSE)