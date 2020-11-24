library(plyr)
library(tidyr)
library(dplyr)

#Merge the training and the test sets to create one data set 
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

test <- cbind(X_test, y_test, subject_test)
train <- cbind(X_train, y_train, subject_train)
merged <- rbind(train, test)

#Rename the variables according to the file features.txt
features <- read.table("features.txt")
names(merged) <- features[,2]
names(merged)[562] <- "activity_labels"
names(merged)[563] <- "subject"

#Extracting only the measurements on the mean and standarsd deviation for each measurement
merged_mean_std <- select(merged, contains("mean"), contains("std"), "activity_labels", "subject")

#Use descriptive activity names to name the activities in the data set in activity_labels.txt
y_labels <- read.table("activity_labels.txt")
merged_mean_std <- mutate(merged_mean_std, activity_labels = y_labels[activity_labels, 2])

# Group by activity and subject then apply mean
tidy_data <- merged_mean_std %>% group_by(subject, activity_labels) %>% summarise(across(everything(), mean))

# Write tidy data in tidy_dataset.txt
write.table(tidy_data, "tidy_dataset.txt")
write.table(names(tidy_data), "tidy_features.txt")




