
##all files downloaded

features_Names <- read.table("UCI HAR Dataset/features.txt")
activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)


## 1. Merges the training and the test sets to create one data set:
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test) 

colnames(X) <- t(features_Names[2])
colnames(y) <- "Activity"
colnames(s) <- "Subject"

dataSet <- cbind(X, y, s)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement:

colMeanSTD <- grep(".*Mean.*|.*Std.*", names(dataSet), ignore.case=TRUE)

requiredCol <- c(colMeanSTD, 562, 563)
dim(dataSet)

selectedCols <- dataSet[,requiredCol]
dim(selectedCols)


## 3. Uses descriptive activity names to name the activities in the data set:

selectedCols$Activity <- as.character(selectedCols$Activity)
for (i in 1:6){
  selectedCols$Activity[selectedCols$Activity == i] <- as.character(activity_Labels[i,2])
}

selectedCols$Activity <- as.factor(selectedCols$Activity)

## 4. Appropriately labels the data set with descriptive activity names:

#names(selectedCols)
names(selectedCols)<-gsub("-std()", "STD", names(selectedCols))
names(selectedCols)<-gsub("-mean()", "Mean", names(selectedCols))
names(selectedCols)<-gsub("^t", "Time", names(selectedCols))
names(selectedCols)<-gsub("^f", "Frequency", names(selectedCols))
names(selectedCols)<-gsub("Acc", "Accelerometer", names(selectedCols))
names(selectedCols)<-gsub("Gyro", "Gyroscope", names(selectedCols))
names(selectedCols)<-gsub("Mag", "Magnitude", names(selectedCols))
names(selectedCols)<-gsub("BodyBody", "Body", names(selectedCols))
names(selectedCols)<-gsub("tBody", "TimeBody", names(selectedCols))
names(selectedCols)<-gsub("-freq()", "Frequency", names(selectedCols))
names(selectedCols)<-gsub("angle", "Angle", names(selectedCols))
names(selectedCols)<-gsub("gravity", "Gravity", names(selectedCols))

names(selectedCols)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(selectedCols, "TidyData.txt", row.name=FALSE)
