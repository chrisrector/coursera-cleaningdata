# This script creates a tidy dataset from the human activity smartphone
# data from this project:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# The output file containts the mean off all the standard deviation and mean
# columns, grouped by the activity and subject. The script assumes certain files
# and directories are present in the working directory, as listed in the first
# section of the script.

# input files we expect to be present:
trainFile = "train/X_train.txt"
testFile = "test/X_test.txt"
featureFile = "features.txt"
testSubjectFile = "test/subject_test.txt"
trainSubjectFile = "train/subject_train.txt"
activityLabelsFile = "activity_labels.txt"
testActivitiesFile = "test/y_test.txt"
trainActivitiesFile = "train/y_train.txt"

# the output file we'll generate in the working directory
outFile = "tidymotiondata.csv"

# first make sure files exist
if (!exist(trainFile) | !exist(testFile)) {
  stop(paste("Could not find both input files", trainFile, "and", testFile)
}

if (!exist(testSubjectFile) | !exist(trainSubjectFile)) {
  stop(paste("Could not find both subject files", 
             testSubjectFile, "and", trainSubjectFile)
}

if (!exist(testActivitiesFile) | !exist(trainSubjectFile)) {
  stop(paste("Could not find both activity files", 
             testActivitiesFile, "and", trainSubjectFile)
}

if (!exist(activityLabelsFile)) {
  stop(paste("Could not find activty labels file", activityLabelsFile)
}

if (!exist(featureFile)) {
  stop(paste("Could not find feature file", featureFile)
}

print("reading in data files...")
rawTrain = read.table(trainFile)
rawTest = read.table(testFile)

# combine data into single data frame
rawAll = rbind(rawTest, rawTrain)

# now determine the indexes for the std and mean columns since we are only
# interested in them
print("determining mean and std columns")
features = read.table(featureFile)
relevantCols <- subset(features, grepl("std\\(\\)|mean\\(\\)", features[,2]))
relevantColNumbers <- relevantCols[,1]
numRelevantCols = length(relevantColNumbers)
trimmedData <- rawAll[,relevantColNumbers]
colnames(trimmedData) <- relevantCols[,2]

# prepare and add the activity data in a separate column
activityLabels = read.table(activityLabelsFile)
testActivities = read.table(testActivitiesFile)
trainActivities = read.table(trainActivitiesFile)
# combine the activity data - important to add the same way as
# the data sets - test and then training data
allActivities = rbind(testActivities, trainActivities)
# now convest to descriptive names (e.g. WALKING)
y = allActivities[,1]
allActivities = sapply(y, 
                       function(x) activityLabels[activityLabels[,1] == x ,2])
trimmedData$activity <- allActivities

# prepare and add the subject data as separate column
testSubjects <- read.table(testSubjectFile)
trainSubjects <- read.table(trainSubjectFile)
# combine the activity data - again it is important to add the same way as
# the data sets - test and then training data
allSubjects = rbind(testSubjects, trainSubjects)
trimmedData$subject <- allSubjects[,1]

# now create the tidy data set containing the means of all the measurements,
# grouped by activity and then subject
tidyData <- aggregate(trimmedData[,1:numRelevantCols], 
                      by=list(trimmedData$activity,trimmedData$subject), 
                      FUN=mean, na.rm=TRUE)

# adjust the column names for the grouping columns, which were lost in the 
# aggregate function
colnames(tidyData)[1] <- 'activity'
colnames(tidyData)[2] <- 'subject'

# now write the tidy data set to file, without row names
write.csv(tidyData, file = outFile, row.names=FALSE)


