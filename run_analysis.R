rm(list=ls())
library(dplyr)
library(readr)
library(tibble)

opened<-"2020-05-05 14:35:36 CDT"
features<- read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/features.txt", col_names = FALSE)

sub_test<-read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)
names(sub_test)[names(sub_test)=="X1"] <- "participant_id"

testy<- read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
names(testy)[names(testy)=="X1"]<-"activity_id"

testx<-read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
for(i in 1:561) {
        x <- paste("X", i, sep = "")
        names(testx)[names(testx) == x]<-as.character(features$X1[i])
}

sub_train<-read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)
names(sub_train)[names(sub_train)=="X1"] <- "participant_id"

trainy<-read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
names(trainy)[names(trainy)=="X1"]<-"activity_id"

trainx<-read_table("~/Rcoursera/gettingdataproject/Getting_Cleaning_Data_Project/UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
for(i in 1:561) {
        x <- paste("X", i, sep = "")
        names(trainx)[names(trainx) == x]<-as.character(features$X1[i])
}

test<-bind_cols(sub_test, testy, testx)
train<-bind_cols(sub_train, trainy, trainx)

rm(features, sub_test, testx, testy, sub_train, trainx, trainy)

total_set<-bind_rows(test, train)

rm(test, train)