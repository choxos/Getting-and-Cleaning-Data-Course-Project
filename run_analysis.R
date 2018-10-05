library(tidyverse)

# Add URL and name of the data set, then check if it exsists, and if it does not exsists, downloads and uzips it
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataName <- "getdata_projectfiles_UCI HAR Dataset.zip"

if(!file.exists(dataName)){
        download.file(dataUrl, dataName, method = "curl")
}
if(!file.exists("UCI HAR Dataset")){
        unzip(dataName)
}

# Load activity labels and features that are stored as tables
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = "label", "activity")
features <- read.table("UCI HAR Dataset/features.txt", col.names = "number", "features")


# There are three data sets in each train and test folders. We read each of them and combine them as train and test datasets.
# Read train datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
y_train_label <- left_join(y_test, activity_labels, by = "label")
train <- cbind(subject_train, y_train_label, x_train)
train <- select(train, -label)

# Read test datasets
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
y_test_label <- left_join(y_test, activity_labels, by = "label")
test <- cbind(subject_test, y_test_label, x_test)
test <- select(test, -label)

# Then we create our final dataset called "allData" by merging train and test datasets
allData <- rbind(train, test)

# We want Standard Deviations and Means, so in this step we extract them
allData_std_mean <- select(allData, contains("mean"), contains("std"))

# In this step we make and average of variable by subject and activity
allData_std_mean$subject <- as.factor(allData$subject)
allData_std_mean$activity <- as.factor(allData$activity)

# Melt the data
allData_melted <- melt(allData, id = c("subject", "activity"))

# Casting the dataframe for mean
allData_mean <- dcast(allData_melted, subject+activity~variable, mean)

# And finally, write the data into a table datafram with .txt format
write.table(allData_mean, "tidy_data.txt", row.names = F, quote = F)