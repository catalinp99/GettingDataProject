# Peer-graded Assignment: Getting and Cleaning Data Course Project

Project assignment.

## Instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

### Review criteria 
1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4. The README that explains the analysis files is clear and understandable.
5. The work submitted for this project is the work of the student who submitted it.

### Getting and Cleaning Data Course Projectless 
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Implementation

The R script that executes the above steps is _[run_analysis.R](run_analysis.R)_. To execute it, download the R file locally, open an R terminal in the same directory and execute `source('run_analysis.R')`

The script will save the tidy data set (as per requirements) in a text file called *summary_mean.txt*, with values separated by space.

The code book for this project is in [CodeBook.md](CodeBook.md)

### R Script steps
* Download and unzip the dataset if not already in the current folder

```{r}
if (!file.exists('UCI HAR Dataset')) {
  zipfile <- 'uci_dataset.zip'
  download.file(
    'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
    destfile = zipfile
  )
  unzip(zipfile, overwrite = TRUE); file.remove(zipfile)
}
setwd("./UCI HAR Dataset")
```

1. Merges the training and the test sets to create one data set.
```{r}
# Load features and activities lookups
features <-
  read_delim("features.txt", col_names = FALSE, delim = ' ') %>% pull(var = 2)
activities <-
  read_delim("activity_labels.txt",
             col_names = c("code", "activity"),
             delim = ' ')

### Helper function
.load <- function(type, dir = getwd()) {
  xdata <-
    read_delim(
      file.path(dir, type, paste('X_', type, '.txt', sep = '')),
      delim = ' ',
      col_types = cols(.default = col_number()),
      col_names = features
    )
  subjects <-
    read_table(
      file.path(dir, type, paste('subject_', type, '.txt', sep = '')),
      col_names = "subject",
      col_types = cols(col_factor())
    )
  ydata <-
    read_table(file.path(dir, type, paste('Y_', type, '.txt', sep = '')), col_names = 'activity')
  bind_cols(subjects, ydata, xdata)
}
# Load test/train data using helper function and merge into one data frame
testdata <- .load('test')
traindata <- .load('train')
alldata <- bind_rows(traindata, testdata)
```

2. Extracts only the measurements on the mean and standard deviation for each measurement.
```{r}
# Keep only the feature columns containing either the 'mean' or 'std' strings 
alldata <-
  select(alldata, subject, activity, contains(c("mean", "std"), ignore.case = FALSE))
```

3. Uses descriptive activity names to name the activities in the data set
```{r}
# Replace the numerical values with string values for activities
alldata <-
  mutate(alldata, activity = activities$activity[alldata$activity]) # todo factorial
```

4. Appropriately labels the data set with descriptive variable names.
```{r}
# Clean and tidy column names
labels <- names(alldata)
labels <- gsub('^t', "time_", labels)
labels <- gsub('^f', "freq_", labels)
labels <- gsub('-', "_", labels)
labels <- gsub('\\(\\)', "", labels)
names(alldata) <- labels
```

```{r}
# Group by activity and subject, and summarise the mean for all the feature columns
grouped_data <-
  alldata %>% group_by(activity, subject) %>% summarise(across(time_BodyAcc_mean_X:freq_BodyBodyGyroJerkMag_std, mean))
# Write the summary dataset into a text file
setwd("..")
write.table(grouped_data, file = "summary_mean.txt", row.names = FALSE)
```

