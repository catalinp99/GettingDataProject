library(readr)
library(dplyr)

# Set working directory
# todo
setwd("~/Dev/Learn/R/GettingDataProject/UCI HAR Dataset")

# Load data
features <-
  read_delim("features.txt", col_names = FALSE, delim = ' ') %>% pull(var = 2)
activities <-
  read_delim("activity_labels.txt",
             col_names = c("code", "activity"),
             delim = ' ')

### Load test and 
type <- "test"
dir <- getwd()
load <- function(type, dir = getwd()) {
  xdata <-
    read_delim(
      file.path(dir, type, paste('X_', type, '.txt', sep = '')),
      delim = ' ', 
      col_types = cols(.default = col_number()),
      col_names = features
    )
  subjects <- read_table(file.path(dir, type, paste('subject_', type, '.txt', sep = '')),
                         col_names = "subject", col_types = cols(col_factor()))
  ydata <- read_table(file.path(dir, type, paste('Y_', type, '.txt', sep = '')), col_names = 'activity')
  bind_cols(subjects, ydata, xdata)
}

testdata <- load('test')
traindata <- load('train')
alldata <- bind_rows(traindata, testdata)

