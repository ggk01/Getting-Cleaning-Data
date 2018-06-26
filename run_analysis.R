
## dowload & unzip files
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
File <- "UCI HAR Dataset.zip"
download.file(Url, File, mode = "wb")
unzip(File)
Path <- "./UCI HAR Dataset/"
######

### read tables
trainingSubjects <- read.table(paste0(Path, "train", "/subject_train.txt"))
trainingValues <- read.table(paste0(Path, "train", "/X_train.txt"))
trainingActivity <- read.table(paste0(Path, "train", "/y_train.txt"))

testSubjects <- read.table(paste0(Path, "test", "/subject_test.txt"))
testValues <- read.table(paste0(Path, "test", "/X_test.txt"))
testActivity <- read.table(paste0(Path, "test", "/y_test.txt"))

features <- read.table(paste0(Path, "/features.txt"), as.is = TRUE)

activities <- read.table(paste0(Path, "/activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")
######

##merge tables
Activity <- rbind(cbind(trainingSubjects, trainingValues, trainingActivity),cbind(testSubjects, testValues, testActivity))
## fix variable titles
colnames(Activity) <- c("subject", features[, 2], "activity")


## keep the desired cols: subject, activity, mean, std
columnsToKeep <- grepl("subject|activity|mean|std", colnames(Activity))
Activity <- Activity[, columnsToKeep]


#replace activity values
Activity$activity <- factor(Activity$activity, levels = activities[, 1], labels = activities[, 2])

ActivityCols <- colnames(Activity)

#grou by subject & sum on mean
ActivityMeans <- Activity %>% 
 group_by(subject, activity) %>%
  summarise_all(funs(mean))

#write changes
write.table(ActivityMeans, "tidy_data.txt", row.names = FALSE, quote = FALSE)



