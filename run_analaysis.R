## Downloading the Dataset & unzipping the file
### Dataset is unzipped with folder name "UCI HAR Dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("Dataset.zip"))
{
  download.file(url,"Dataset.zip",mode="wb")
}
unzip("Dataset.zip")

## Reading feature file

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

### Merging the training and the test sets to create one data set.
train_df <- data.frame(y_train,subject_train,X_train)
test_df <-  data.frame(y_test, subject_test, X_test)
df <- rbind(train_df,test_df)
labels <- c("Activity","SubjectID",as.character(paste(features[,1],features[,2],sep="_")))
names(df) <- labels

library(dplyr)
library(tidyr)

# Extracting only the measurements on the mean and standard deviation for each measurement. 
# Assumption: mean() & std() are assumed as the only variables which are mean & std computations

df_mean <- select(df, contains("mean()"))
df_std  <- select(df, contains("std()"))

# From the data set creates a second, independent tidy data set with the average of each variable for each activity and each subject.
har_mean_std <- data.frame(df[,1:2], df_mean, df_std)
by_aid_sid <- group_by(har_mean_std, Activity, SubjectID)
mean_aid_sid <- summarise_each(by_aid_sid, funs(mean), 3:68)

# Appropriately labels the data set with descriptive variable names. 
nms <- c(names(df_mean),names(df_std))
idx_num <- unlist(gregexpr('_', proc_nms))
proc_nms <- substring(proc_nms, idx_num)                  
proc_nms <- paste0("mean",proc_nms)
names(mean_aid_sid)[3:ncol(mean_aid_sid)] <- proc_nms

write.table(mean_aid_sid,"har_tidy.txt", row.names = FALSE)
