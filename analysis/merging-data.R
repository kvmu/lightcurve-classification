# This script merges the given features with the calculated features from FATS
library(dplyr)
library(readxl)

# authors: Rachel Z. (rachzili13), Yao Shi (yaoshi1994), and Kevin M. (kvmu)


####### Make sure you comment/uncomment the respective lines for training vs
####### test! It's kind of lazy on my part -- it's the quickest way for now.

# Set working directory
workshop_home <- "C:/Users/kevin/Desktop/mayug/lightcurves/data/"
setwd(workshop_home)

# Load the given training set (contains old features)
#load("training_set.RData")

# Load the given test set (contains old features, no labels)
load("test_set.RData")

# Load the calculated features
#stars <- read_excel('train_stardata.xlsx')
stars <- read_excel('stardata.xlsx')

# Make sure that the types for the IDs match
stars$ID <- as.character(stars$ID)
#training_set_features$ID <- as.character(training_set_features$ID)
test_set_features$ID <- as.character(test_set_features$ID)

# Join the data
#merged = inner_join(training_set_features, stars, by = "ID")
merged = inner_join(test_set_features, stars, by = "ID")

# Do some data management (remove duplicate measures, placement of response, etc.)
merged$V_mag <- NULL
merged$Class <- NULL
merged$PeriodLS <- NULL

# Hacky way of placing the response at the end without messing around with the
# order of everything else :)
classes <- merged$class
merged$class <- NULL
merged["class"] <- classes


# Export the data as analysis-training
write.csv(file = "analysis-test.csv", x = merged, row.names = F)
