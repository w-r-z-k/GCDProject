# This script (run_analysis.R) takes the UCI HAR dataset and does the following:
#
# General setup work
# Step 1. Merge the training and the test sets to create one data set.
# Step 2. Extracts only the measurements on the mean and standard deviation
# Step 3: Uses descriptive activity names to name the activities in the data set
# Step 4: Appropriately labels the data set with descriptive activity names. 
# Step 5: Creates a second, independent tidy data set with avg of ea. variable
#         for ea. activity and ea. subject. 
#

outputfilename="GCDProject_UCIHARTidyData.txt"
outputfilename2="GCDProject_UCIHARTidyData_Averages.txt"

# General setup work ...

setwd("/home/user/Projects/DataScience/GettingAndCleaningData/Project/GCDProject")
unzip("UCI HAR Dataset.zip")
setwd("./UCI HAR Dataset")
getwd()

# Step 1. Merge the training and the test sets to create one data set.
# -------
#
# - 'X_train.txt': Training set.    (i.e. 561 feature values per measurement)  7352x561
# - 'y_train.txt': Training labels. (i.e. activity label for each measurement) 7352x1
#
# note: it would be more memory efficient to merge later but I decided to 
#       follow the specified path in the project outline.

# Read in the training datasets
setwd("./train")
xtrain <- read.table("X_train.txt")
activity.train <- read.table("y_train.txt")
subject.train <- read.table("subject_train.txt")

train <- cbind(activity.train,subject.train,xtrain)

# Read in the training datasets
setwd("../test")
xtest <- read.table("X_test.txt")
activity.test <- read.table("y_test.txt")
subject.test <- read.table("subject_test.txt")

test <- cbind(activity.test,subject.test,xtest)

# Merge the two sets of data

alldata <- rbind(test,train)

# Set the column labels for the first two columns

names(alldata)[1] <- "activity.id"
names(alldata)[2] <- "subject.id"

# Step 2. Extracts only the measurements on the mean and standard deviation
# ------- for each measurement. 
#
# 'features.txt': List of all features.

setwd("..")
getwd()
features.labels <- read.table("features.txt")
names(features.labels) <- c("index","varname")

# shift index over by two to accomodate the subject and the y index

features.labels$index <- features.labels$index + 2

# Select only those variable names which contain -mean() or -std()

mean_or_std <- grep(".*-mean[(].*|.*-std[(].*",features.labels[,2],ignore.case=TRUE)

selected.features <- features.labels[mean_or_std,]

# Set the first 2 labels to match the first two columns

first.column <- as.data.frame(list(1,"activity.id"))
names(first.column) <- c("index","varname")

second.column <- as.data.frame(list(2,"subject.id"))
names(second.column) <- c("index","varname")

selected.features <- rbind(first.column, second.column, selected.features)

# Select the columns from the x dataframe based on the selected features 
# determined above.

alldata <- alldata[,selected.features$index]

if (ncol(alldata) != nrow(selected.features)) {
  print("ERROR: alldata does not have the same # of columns as in the label vector")
}

# Step 3: Uses descriptive activity names to name the activities in the data set
# -------

# 'activity_labels.txt': Links the class labels with their activity name. 561x2

activity.labels <- read.table("activity_labels.txt")
names(activity.labels) <- c("activity.id","activity")

alldata <- merge(activity.labels,alldata)

# Remove the activity.id column now that we have proper activity labels

alldata <- alldata[,2:ncol(alldata)]

first.column <- as.data.frame(list(1,"activity"))
names(first.column) <- c("index","varname")

selected.features <- rbind(first.column, selected.features[2:nrow(selected.features),])

# Step 4: Appropriately labels the data set with descriptive activity names. 
# -------
# note: This this was done in 'step 3', I'm going to assume they mean that
#       the 'feature' names should be descriptive.

# First, clean up the variable names
#
# note: I will separate the words with a period as per the Google coding standard for R

selected.features$varname <- gsub("[()]","",tolower(selected.features$varname))
selected.features$varname <- gsub("-",".",selected.features$varname)

# Set the column names to properly describe the feature in the column

names(alldata) <- selected.features$varname

# This should contain 10299 rows

if (nrow(alldata) != 10299) {
  print("ERROR: The result does not contain 10299 rows")
}

# Now we can combine the parts and write it out

setwd("..")
getwd()
write.table(alldata,file=outputfilename,row.names=FALSE)

table(alldata$activity,alldata$subject.id)

# Step 5: Creates a second, independent tidy data set with the average of each 
# ------- variable for each activity and each subject. 

install.packages("reshape2", repos='http://cran.us.r-project.org')
library(reshape2)

melt.alldata <- melt(alldata, id=c("activity","subject.id"))

averaged.data <- dcast(melt.alldata, activity + subject.id ~ variable, fun.aggregate=mean)

nrow(averaged.data)
head(averaged.data,5)
str(averaged.data)
table(averaged.data$activity,averaged.data$subject.id)

str(averaged.data)

write.table(averaged.data,file=outputfilename2,row.names=FALSE)

