# Downloading and unziping the Data set
rm(list=ls())
date()
base_path <- 'C:/Users/andre/Desktop/CURSO DATA SCIENCE JH/Getting and cleaning data/datasciencecoursera/Final Project'
setwd(base_path)
URL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('TidyData')) {dir.create('TidyData')}
base_path <- 'C:/Users/andre/Desktop/CURSO DATA SCIENCE JH/Getting and cleaning data/datasciencecoursera/Final Project'
setwd(base_path)
download.file(URL, destfile = 'data.zip', method = "curl")
unzip('data.zip')
base_path <- 'C:/Users/andre/Desktop/CURSO DATA SCIENCE JH/Getting and cleaning data/datasciencecoursera/Final Project'
setwd(base_path)

# Create paths and extract the column names

test_path <- paste(base_path, '/test', sep = '')
train_path <- paste(base_path, '/train', sep = '')
raw_names <- read.table(paste(base_path, '/features.txt', sep = ''))
col_names <- t(raw_names[-1])

# Read all the training data and binding them 
train_prev <- read.table(paste(train_path, '/X_train.txt', sep = ''))
train_subject <- read.table(paste(train_path, '/subject_train.txt', sep = ''))
train_activity <- read.table(paste(train_path, '/y_train.txt', sep = ''))
train <- cbind(train_prev, train_subject, train_activity)
dim(train)

# Read all the testing data and binding them 
test_prev <- read.table(paste(test_path, '/X_test.txt', sep = ''))
test_subject <- read.table(paste(test_path, '/subject_test.txt', sep = ''))
test_activity <- read.table(paste(test_path, '/y_test.txt', sep = ''))
test <- cbind(test_prev, test_subject, test_activity)
dim(test)

# merging training and testing data sets
data <- rbind(train, test)
data_dim <- dim(data)

new_cols <- raw_names[which(grepl(pattern = "std\\(\\)|mean\\(\\)", x = raw_names[, 2])), ]
new_data <- data[, c(new_cols[, 1], data_dim[2] - 1, data_dim[2])]
dim(new_data)

activity_labels <- read.table(paste(base_path, '/activity_labels.txt', sep = ''), col.names = c('id', 'activity.label'))
colnames(new_data) <- t(new_cols[, 2])
names(new_data)[67] <- "subject"
names(new_data)[68] <- "activity"

# Merge de data using activity and id labels
merged_data <- merge(new_data, activity_labels, by.x = "activity", by.y = "id")

# Check the obtained table
table(merged_data[, c("activity", "activity.label")])

# It's doing in above point, just check it!
str(merged_data)

tidyData <- aggregate(merged_data[, 2:67], by = list(merged_data$subject, merged_data$activity.label), FUN = mean)
# Check first rows of the tidy data
head(tidyData)

# Check last rows of the tidy data
tail(tidyData)

# Check whole rows of the tidy data
View(tidyData)

result <- "tidydata.txt"
getwd()
write.table(tidyData, file = result, row.names = TRUE)
dim(tidyData)

# Show whole the tidying data read
View(read.table(RESULT, header = TRUE))

