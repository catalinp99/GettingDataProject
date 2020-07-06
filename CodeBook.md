---
title: "Code Book"
---

**These operation have been performed against the original _UCI HAR Dataset_ dataset.**

1. Load the following datasets into variables and merge them into a single dataset

 * _features_ <- _features.txt_: 561 elements  
 Vector with all the names of the features measured in the experiment.

 * _activities_ <- _activity_labels.txt: 6 rows, 2 columns  
 A ldata frame of the activities performed when the feature measurement was executed, in the format: name, code.
 * _testdata_: 2947 observations of 563 variables (activity, subject and the 561 measured features)
 * _traindata_: 7352 observations of 563 variables (activity, subject and the 561 measured features)

    Both train and test data have been constructed by following theses steps from the corresponding folder ('train' or 'test'). The train and test datasets have 7352 respectivelly 2947 observations. 
      * Load _Y_ dataset (e.g. Y_test.txt). This dataset contains the activity code for each observation.
      * Load _subject_ dataset (e.g. subject_test.txt). This dataset contains the subject code (a number from 1 to 30) for each observation
      * Load _X_ dataset (e.g. X_test.txt) by using the the features as column (variable) names. This daset contains the feature measurements for each observation.
      * Merge the variables/observations from the above datasets into a single dataset  

 * _alldata_: _testdata_ and _traindata_ merged into a single dataset: 10299 observation of 563 variables

2. Tidy _alldata_ dataset

* Keep only the feature columns related to either Standard Deviation or Mean, that is a total of 81 variables
* Replace the activity codes (e.g. 1) with the more verbose activity names (e.g. WALKING)
* Change the feature variable names (labels) as follows:
  + leading 't' replaced by 'time'
  + leading 'f' replaced by 'freq'
  + '-' replaced by '_'
  + removed paranthesis: '(', ')'

3. Summarize the features mean by activity and subject

* Create a new dataset _grouped_data_ by first grouping by activity and subject, followed by summarizing the mean of all the feature variables: 180 observations of 81 variables
* Export the above dataset into a text file *summary_mean.txt*
