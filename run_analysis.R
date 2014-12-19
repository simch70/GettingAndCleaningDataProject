# 0. Reads base information

features <- read.csv("./UCI HAR Dataset/features.txt", header<-FALSE, sep="",
                     col.names=c("feature_index", "feature_name"),
                     colClasses=c("numeric", "character"))

activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", 
                          header=FALSE, sep="",col.names=c("activity", "activity_name"))


# 1. Merges the training and the test sets to create one data set.

x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", header<-FALSE, sep="")
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", 
                          header=FALSE, sep="", col.names="subject")
activity_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", 
                           header=FALSE, sep="", col.names="activity")

x_train <- cbind(activity_train, cbind(subject_train, x_train))

x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", header<-FALSE, sep="")
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", 
                          header=FALSE, sep="", col.names="subject")
activity_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", 
                           header=FALSE, sep="", col.names="activity")

x_test <- cbind(activity_test, cbind(subject_test, x_test))

dataSet <- rbind(x_train, x_test)


# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 

selected_features <- features[grep("mean\\(|std\\(", features$feature_name),]

dataSet <- dataSet[, c(1, 2, selected_features$feature_index + 2)]


# 3. Uses descriptive activity names to name the activities in the data set

dataSet <- merge(activity_labels, dataSet)
dataSet$activity <- NULL


# 4. Appropriately labels the data set with descriptive variable names. 

names(dataSet)[-(1:2)] <- selected_features$feature_name


# 5. Creates a second, independent tidy data set with the average of
#    each variable for each activity and each subject.

setMelt <- melt(dataSet, id=c("activity_name", "subject"),
                measure.vars=selected_features$feature_name)

tidySet <- dcast(setMelt, activity_name + subject ~ variable, mean)


# 6. Writes tidy data set

write.table(tidySet, file = "./dataset.txt", row.names=FALSE)

