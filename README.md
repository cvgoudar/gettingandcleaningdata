# RUN ANALYSIS

## Objective

The exercise results in creating a tidy set for Human Activity Recognition (HAR) data. The analysis was done in Multiple phases


## Download & extract the files

The HAR data is available as a dataset in zip format in the provided url.

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("Dataset.zip"))
{
  download.file(url,"Dataset.zip",mode="wb")
}
unzip("Dataset.zip")
```
