library(readr)
library(dplyr)

# Download the data if needed
if (!file.exists('UCI HAR Dataset')) {
  zipfile <- 'uci_dataset.zip'
  download.file(
    'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
    destfile = zipfile
  )
  unzip(zipfile, overwrite = TRUE); file.remove(zipfile)
}
setwd("./UCI HAR Dataset")

### 1. Merges the training and the test sets to create one data set.
# Load data
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

testdata <- .load('test')
traindata <- .load('train')
alldata <- bind_rows(traindata, testdata)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
alldata <-
  select(alldata, subject, activity, contains(c("mean", "std"), ignore.case = FALSE))

### 3. Uses descriptive activity names to name the activities in the data set
alldata <-
  mutate(alldata, activity = activities$activity[alldata$activity]) # todo factorial

### 4. Appropriately labels the data set with descriptive variable names.
labels <- names(alldata)
labels <- gsub('^t', "time_", labels)
labels <- gsub('^f', "freq_", labels)
labels <- gsub('-', "_", labels)
labels <- gsub('\\(\\)', "", labels)
names(alldata) <- labels

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
grouped_data <-
  alldata %>% group_by(activity, subject) %>% summarise(across(time_BodyAcc_mean_X:freq_BodyBodyGyroJerkMag_std, mean))
setwd("..")
write.table(grouped_data, file = "clean_data.txt", row.names = FALSE)

print(grouped_data)
