# MAYUG Workshop

# This is the analysis script for the Lightcurves project. The classifier is 
# first constructed using the training data, and then evaluated using the test
# data. The lightcurve data is taken from a subset of the Catalina Survey:
# doi:10.1088/0067-0049/213/1/9

# Libraries
library(randomForest)
library(ggplot2)

# Set working directory
workshop_home <- "C:/Users/kevin/Desktop/mayug/lightcurves/data/"
setwd(workshop_home)

# Load the training data
training <- read.csv('analysis-training.csv')

# Load the test data
test <- read.csv('analysis-test.csv')


###############################################################################
#                           BUILDING THE CLASSIFIER                           #
###############################################################################
star.forest <- randomForest(class ~ . -ID , data = training, ntree = 500,
                            importance=TRUE,
                            proximity=TRUE)


# Determine the relative importance of the variables
# First create a dataframe containing the absolute importance values
im <- as.data.frame(importance(star.forest))
names <- as.data.frame(rownames(im))
im <- as.data.frame(cbind(names,im$MeanDecreaseGini))
colnames(im) <- c("feature","importance")

# Now create a relative importance and sort from smallest to largest
im$importance <- im$importance/sum(im$importance)
im <- m[order(im$importance,decreasing = T),]

# Plot the entire variable list
ggplot(im, aes(x=reorder(feature, importance), y=importance)) + 
    geom_bar(stat="identity") + 
    coord_flip() + 
    labs(x="Feature") + labs(y="Importance")

# Plot the top 10 important variables
top10 <- im[1:10,]
ggplot(top10, aes(x=reorder(feature, desc(importance)), y=importance)) + 
    geom_bar(stat="identity") + 
    coord_flip() + 
    labs(x="Feature")

###############################################################################
#                           FEATURE IMPORTANCE TEST                           #
###############################################################################
oob.err.rate <- vector(length = 44)

for(i in 10:54){
    print(i)
    top.i <- im[1:i, ]
    top.i.model <- paste("class ~ ", paste(top.i$feature, collapse = " + "), sep="")
    star.forest <- randomForest(as.formula(top10.model), data = training, ntree = 500,
                                importance=TRUE,
                                proximity=TRUE)
    oob.err.rate[i-9] <- star.forest$err.rate[, 1][500]
}

x <- 10:54
y <- oob.err.rate
experiment <- as.data.frame(cbind(x,y)) #used for plotting later


# i = 32 is optimal for the above settings

###############################################################################
#                           TEST CLASSIFICATION                               #
###############################################################################

opt.model <- paste("class ~ ", paste(im[1:32,]$feature, collapse = " + "), sep="")
opt.star.forest <- randomForest(as.formula(opt.model), data = training, ntree=500)

# Primary goal
predicted.labels <- predict(opt.star.forest, test)
load('test_set_classes.RData')
mean(predicted.labels == test_classes) ## el fuego loco 0.8159403

# Secondary Goal
eclipsing.names <- c("beta_lyrae", "EA", "EW", "PCEB")
eclipsing.predict <- predicted.labels %in% eclipsing.names
eclipsing.truth <- test_classes %in% eclipsing.names

total.correct <- sum(eclipsing.predict == eclipsing.truth)

binary.efficiency <- total.correct/length(test_classes) # crush, 90.60%

###############################################################################
#                               Plots                                         #
###############################################################################

# Determine the relative importance of the variables and plot for the optimal
# star forest!
# First create a dataframe containing the absolute importance values
im <- as.data.frame(importance(opt.star.forest))
names <- as.data.frame(rownames(im))
im <- as.data.frame(cbind(names,im$MeanDecreaseGini))
colnames(im) <- c("feature","importance")

# Now create a relative importance and sort from smallest to largest
im$importance <- im$importance/sum(im$importance)
im <- m[order(im$importance,decreasing = T),]

# Plot the entire variable list
ggplot(im, aes(x=reorder(feature, importance), y=importance)) + 
    geom_bar(stat="identity") + 
    coord_flip() + 
    labs(x="Feature") + labs(y="Importance")


# Plot the Out of Bag Error Rate vs. no. features
ggplot(experiment, aes(x=x, y=y)) + geom_point(shape=1) + 
    geom_smooth(method=loess) + labs(x="Number of Features Used (Ranked by Importance)") +
    labs(y="OOB Error Rate")


