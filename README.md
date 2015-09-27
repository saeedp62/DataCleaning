# DataCleaning
This is a public Repo for Data Science Specialization

# Getting and cleaning data

For creating a tidy data set of wearable computing data originally from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Files in this repo
* README.md -- you are reading it right now
* CodeBook.md -- codebook describing variables, the data and transformations
* run_analysis.R -- actual R code

## run_analysis.R goals
You should create one R script called run_analysis.R that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The code does not assume any specific working directory 
The script download the ZIP file form the gven URL and unzipp it. 
(the zip has this folder in it: UCI HAR Dataset)
Then changes the working directory to the "UCI HAR Dataset" which contain the followings:
* activity_labels.txt
* features.txt
* test/
* train/

The output is created in working directory with the name of tidyData.txt


## run_analysis.R walkthrough
It follows the goals step by step.

* Step 1:
  * Read all the test and training files: y\_test.txt, subject\_test.txt and X_test.txt.
  * Combine the files to a data frame in the form of subjects, labels, the rest of the data.

* Step 2:
  * Read the features from features.txt and filter it to only leave features that are either means ("mean()") or standard deviations ("std()"). The reason for leaving out meanFreq() is that the goal for this step is to only include means and standard deviations of measurements, of which meanFreq() is neither.
  * A new data frame is then created that includes subjects, labels and the described features.

* Step 3:
  * Read the activity labels from activity_labels.txt and replace the numbers with the text.

* Step 4:
  * Make a column list (includig "subjects" and "label" at the start)
  * Tidy-fy the list by removing all non-alphanumeric characters
  
* Step 5:
  * Create a new data frame by finding the mean for each combination of subject and label. It's done by `aggregate()` function
  
* Final step:
  * Write the new tidy set into a text file called tidyData.txt, formatted similarly to the original files.
