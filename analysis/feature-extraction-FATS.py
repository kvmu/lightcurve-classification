# -*- coding: utf-8 -*-
"""
Created on Tue May 16 11:08:09 2017

@author: kevin
"""
# Module Imports
import FATS as fats
from numpy import loadtxt, copy
from os import listdir
import xlsxwriter

# Simple timer
from datetime import datetime
class timer:
    def __enter__(self):
        self.start = datetime.now()
        return self

    def __exit__(self, type, value, traceback):
        self.end = datetime.now()
        print "time: %s" % (self.end - self.start)


## Main Script Begins

# Define data directory
data_directory = 'C:/Users/kevin/Desktop/mayug/lightcurves/data/raw-lc-test_17-05-2017_2141'

# Are you doing a training set or a test set?
isTrain = False

# Contextual timer
with timer() as t:
    # Get all of the star filenames
    starnames = listdir(data_directory)

    # Container for the feature data for each star
    datas = []

    # Iterate over all the stars
    for i in xrange(len(starnames)):
        #if i == 10: break
        print i
        star_i = starnames[i]
        star_data = loadtxt(data_directory + "\\" + star_i,
                               skiprows=1,  usecols=(1,2,3), delimiter=',', )

        # Swap numpy columns (needed for input to FATS package)
        temp = copy(star_data[:, 0])
        star_data[:, 0] = star_data[:, 1]
        star_data[:, 1] = temp
        star_data = star_data.T

        # FATS module
        feature_extractor = fats.FeatureSpace(Data=['magnitude', 'time', 'error'],
                                              excludeList = ['Color','Eta_color',
                                              'Q31_color', 'StetsonJ', 'StetsonL',
                                              'StetsonK_AC', 'SlottedA_length',
                                              'Eta_e', 'CAR_mean', 'CAR_sigma',
                                              'CAR_tau', 'MaxSlope'])

        # Calculate the features
        feature_extractor = feature_extractor.calculateFeature(star_data)

        # Feature names, and values
        feature_names = feature_extractor.featureList
        features = feature_extractor.result(feature_extractor)

        # Create dictionary with {name:value} pairs
        # FATS is supposed to do this on the .result() class function, but
        # seems like there are some
        data = {k:v for (k, v) in zip(feature_names, features)}

        if isTrain:
            # Include star ID and Class in the dictionary
            data["ID"] = star_i.split("-")[0]
            data["Class"] = star_i.split("-")[1].split(".")[0]
        else:
            data["ID"] = star.split('-')[1].split('.')[0]

        # Append final star information to datas[] containter
        datas.append(data)

# Write data into excel file
workbook = xlsxwriter.Workbook(isTrain*'train_' + 'stardata.xlsx')
worksheet = workbook.add_worksheet()

# Row and column indices to write into excel file
row = 0
col = 0

# Write keys as column names in excel file
for key in datas[0].keys():
    worksheet.write(row, col, key)
    col+=1

# Write values for all stars to corresponding column
for i, d in enumerate(datas):
    col = 0
    row = i+1
    for key, value in d.items():
        worksheet.write(row, col, value)
        col+=1

# Close the excel file
workbook.close()
