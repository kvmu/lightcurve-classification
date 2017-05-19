# This script is designed to extract all the training 
# lightcurve data and put it into a format where it can be read in by python; 
# the main goal here is to extract features using a python package called FATS

# author: Kevin M. (kvmu)

# CLEAR workspace
# WARNING: save your work first! 


# Set working directory
workshop_home <- "C:/Users/kevin/Documents/GitHub/lightcurve-classification/data/"
setwd(workshop_home)

# Load test set
load("test_set.RData")

# Create a directory for  the current export process
foldername <- paste('raw-lc-test', format(Sys.time(), format='%d-%m-%Y_%H%M'), sep = "_")
dir.create(foldername)

# Go through each entry of the lightcurve list and save it as a raw csv file.
# This will be the 'interface' with python, filenames will be ID_CLASS.csv 

for(i in 1:length(test_set_lcs)){
    star.i <- test_set_lcs[[i]]
    star.id <- as.character(star.i$ID[1])
    filename <- paste("test-", star.id, ".csv", sep = "")
    write.csv(file = paste("./", foldername,"/", filename, sep = "") , x=star.i, row.names = F)
}