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

## Combining the data sets

The training & test data set was combined to form a single data set. It was observed that the variable header names were not unique. Hence the labels were concatenated to create unique header names.

```{r}
# joining the datasets
train_df <- data.frame(y_train,subject_train,X_train)
test_df <-  data.frame(y_test, subject_test, X_test)
df <- rbind(train_df,test_df)
labels <- c("Activity","SubjectID",as.character(paste(features[,1],features[,2],sep="_")))
names(df) <- labels
```

## Selection of mean() & std() variables

As per the exercise variables relevant to mean() & std() functions were extracted to a new data set. It was assumed variables containing mean() & std() only are relevant variables. Separately extracted tables for mean() & std() were concatenated.

```{r}
library(dplyr)
library(tidyr)

# Extract measurements on the mean and standard deviation for each measurement. 
df_mean <- select(df, contains("mean()"))
df_std  <- select(df, contains("std()"))
har_mean_std <- data.frame(df[,1:2], df_mean, df_std)
```
## Summarizing the average of variables

summarize_each function of dplyr package was used to find the average of each variable grouped by Subject & Activity. The table has summarized values for each variable in long format.

```{r}
by_aid_sid <- group_by(har_mean_std, Activity, SubjectID)

mean_aid_sid <- summarise_each(by_aid_sid, funs(mean), 3:68)

nms <- c(names(df_mean),names(df_std))
idx_num <- unlist(gregexpr('_', proc_nms))
proc_nms <- substring(proc_nms, idx_num)                  
proc_nms <- paste0("mean",proc_nms)
names(mean_aid_sid)[3:ncol(mean_aid_sid)] <- proc_nms
```

## Writing the output to text file

Text file is created without row names for the tidy data.

```{r}
write.table(mean_aid_sid,"har_tidy.txt", row.names = FALSE)
```
