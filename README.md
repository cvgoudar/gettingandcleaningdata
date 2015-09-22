# RUN ANALYSIS

## Objective

The exercise results in creating a tidy set for Human Activity Recognition (HAR) data. The analysis was done in Multiple phases


## Download & Extract the files

The HAR data is available as a dataset in zip format in the provided url.

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("Dataset.zip"))
{
  download.file(url,"Dataset.zip",mode="wb")
}
unzip("Dataset.zip")
```

## Data Ingestion from files into R data frames

The content is organized in multiple folders. After understand the structure of the data in the folder, the relevant features, training & test data is loaded into R tables

```{r}
# Reading Features & Activity Labels content
features_fname <- "UCI HAR Dataset/features.txt"
features <- read.table(features_fname, col.names=c("featureIdx","featureName"))

activity_labels_fname <- "UCI HAR Dataset/activity_labels.txt"
activity_labels <- read.table(activity_labels_fname, col.names=c("activityIdx","activityName"))

# Reading Train dataset
subject_train_fname <- "UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.table(subject_train_fname)
X_train_fname <- "UCI HAR Dataset/train/X_train.txt"
X_train <- read.table(X_train_fname)
y_train_fname <- "UCI HAR Dataset/train/y_train.txt"
y_train <- read.table(y_train_fname)

# Reading Test dataset
subject_test_fname <- "UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(subject_test_fname)
X_test_fname <- "UCI HAR Dataset/test/X_test.txt"
X_test <- read.table(X_test_fname)
y_test_fname <- "UCI HAR Dataset/test/y_test.txt"
y_test <- read.table(y_test_fname)
```
