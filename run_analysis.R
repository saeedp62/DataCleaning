# Looking for "Datacleaning" folder and creating that incase of non-existence

if(!file.exists("DataCleaning")){dir.create("Datacleaning")}

# change the working directory
setwd("./Datacleaning")

# Assigning the URL of the dataset
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Downloading and unzipping the file from the URL
download.file(URL,"dataset.zip", mode = "wb")
unzip("dataset.zip")

# change the working directory
setwd("./UCI HAR Dataset")


# loading the required libraries
library(data.table)
library(dplyr)

## STEP 1

# Reading the train data
Xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt", col.names = "label")
Subjecttrain <- read.table("./train/subject_train.txt", col.names = "subject")

# put it together in the format of: subjects, labels, everything else
train.data <- cbind(Subjecttrain,ytrain,Xtrain)

# Reading the test data 
Xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt", col.names = "label")
Subjecttest <- read.table("./test/subject_test.txt", col.names = "subject")

# put it together in the format of: subjects, labels, everything else
test.data <- cbind(Subjecttest,ytest,Xtest)

# merging the training and testing data
data <- merge(train.data,test.data, all = TRUE)


## STEP 2

# Loading the feature name
features <- read.table("./features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# only retain the features of mean and standard deviation by pattern matching
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# select only the means and standard deviations from data
# increment by 2 because data has subjects and labels in the first two columns
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## STEP 3

# read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

# use descriptive activity names by
# replacing labels numbers in data with the corresponding label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## STEP 4

# Remove the non-alphabetic characteres from the variable names
variable.names <- gsub("[^[:alpha:]]", "", features.mean.std$V2)

# change the name of the columns to the descripive variable names 
# The code do not change the name of first two columns
colnames(data.mean.std)[-c(1,2)] <- variable.names

## STEP 5 

# find the mean for each combination of subject and label
# ignoring the first two columns in the data.table
aggr.data <- aggregate(data.mean.std[-c(1,2)],
                       by=list(subject = data.mean.std$subject, label = data.mean.std$label), mean)


# write the data for course upload
write.table(format(aggr.data, scientific=T), "tidyData.txt",
            row.names= FALSE, col.names= FALSE, quote=2)
