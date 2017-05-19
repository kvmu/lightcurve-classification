# This script is designed to extract all the training 
# lightcurve data and put it into a format where it can be read in by python; 
# the main goal here is to extract features using a python package called FATS

# author: Kevin M. (kvmu)

# CLEAR workspace
# WARNING: save your work first! 


# Set working directory
workshop_home <- "C:/Users/kevin/Desktop/mayug/lightcurves/data/"
setwd(workshop_home)

# Load training set
load("training_set.RData")

# Attach the training data feature set
# This makes each of the columns of training_set_features a variable you can directly call by its name
attach(training_set_features)

# Create a directory for  the current export process
foldername <- paste('raw-lc', format(Sys.time(), format='%d-%m-%Y_%H%M'), sep = "_")
dir.create(foldername)

# Go through each entry of the lightcurve list and save it as a raw csv file.
# This will be the 'interface' with python, filenames will be ID_CLASS.csv 
count = 0 
for(i in 1:nrow(training_set_features)){
    star.i <- training_set_lcs[[i]] # get the i th star; a dataframe
    star.id <- as.character(star.i$ID[1]) # get the id of the star (for the filename)
    
    # If the ID is NA, go to the next iteration of the for-loop
    if(is.na(star.id)){
        next
    }
    
    class.name <- as.character(training_set_features$class[i]) # get the class (for the filename)
    filename <- paste(star.id, "-", class.name, ".csv", sep = "") # create filename
    write.csv(file = paste("./",foldername,"/", filename, sep = "") , x=star.i, row.names = F)
}