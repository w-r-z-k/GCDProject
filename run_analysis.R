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
ytrain <- read.table("y_train.txt")
subject.train <- read.table("subject_train.txt")

# Read in the training datasets
setwd("../test")
xtest <- read.table("X_test.txt")
ytest <- read.table("y_test.txt")
subject.test <- read.table("subject_test.txt")

# Merge the two sets of data

x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subject <- rbind(subject.train, subject.test)

names(subject) <- "subject"
str(subject)
names(y) <- "activity.id"
str(y)

# Step 2. Extracts only the measurements on the mean and standard deviation
# ------- for each measurement. 
#
# 'features.txt': List of all features.

setwd("..")
getwd()
features.labels <- read.table("features.txt")
names(features.labels) <- c("index","varname")
features.labels

# Select only those variable names which contain -mean() or -std()

mean_or_std <- grep(".*-mean[(].*|.*-std[(].*",features.labels[,2],ignore.case=TRUE)

selected.features <- features.labels[mean_or_std,]
selected.features

# Select the columns from the x dataframe based on the selected features 
# determined above.

x.selected <- x[selected.features$index]
head(x.selected,10)
str(x.selected,10)

# Step 3: Uses descriptive activity names to name the activities in the data set
# -------

# 'activity_labels.txt': Links the class labels with their activity name. 561x2

activity.labels <- read.table("activity_labels.txt")
names(activity.labels) <- c("activity.id","activity")
activity.labels

str(y)

y <- merge(y,activity.labels)["activity"]

head(y,10)


# Step 4: Appropriately labels the data set with descriptive activity names. 
# -------
# note: This this was done in 'step 3', I'm going to assume they mean that
#       the 'feature' names should be descriptive.

# First, clean up the variable names
#
# note: I will separate the words with a period as per the Google coding standard for R

selected.features$varname <- gsub("[()]","",tolower(selected.features$varname))
selected.features$varname <- gsub("-",".",selected.features$varname)
selected.features

# Set the column names to properly describe the feature in the column

names(x.selected) <- selected.features$varname
str(x.selected)

# These should all contain 10299 rows

nrow(y)
nrow(x.selected)
nrow(subject)

# Now we can combine the parts and write it out

final <- cbind(subject,y,x.selected)
str(final)

setwd("..")
write.table(final,file=outputfilename,row.names=FALSE)

# Step 5: Creates a second, independent tidy data set with the average of each 
# ------- variable for each activity and each subject. 

install.packages("reshape2", repos='http://cran.us.r-project.org')
library(reshape2)

melt.final <- melt(final, id=c("subject", "activity"))

final2 <- dcast(melt.final, subject + activity ~ variable, fun.aggregate=mean)

str(final2)

write.table(final2,file=outputfilename2,row.names=FALSE)
