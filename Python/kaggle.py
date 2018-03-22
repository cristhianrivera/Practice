# -*- coding: utf-8 -*-
"""
Created on Thu Mar 22 14:45:23 2018

@author: a688291
"""
import os
import csv
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


os.getcwd()
os.chdir('C:/Users/a688291/Documents/EDA_CRJR/Kaggle')


#Read the information
with open('train_sample.csv', 'rb') as f:
    reader = csv.reader(f)
    kaggle_data = list(reader)

#some format
kaggle_data = pd.DataFrame(kaggle_data[1:], columns = kaggle_data[0])

#check the first 10 rows
kaggle_data[:10]

kaggle_data['is_attributed'] = pd.to_numeric(kaggle_data['is_attributed'])
kaggle_data['click_time'] = pd.to_datetime(kaggle_data['click_time'])
#kaggle_data.loc[kaggle_data.is_attributed == 1, ['device'] ]

##Some numbers
kaggle_data['counting'] = 1
kaggle_data[:10]

kaggle_data.groupby(['app'])['counting'].sum()
kaggle_data.groupby(['device'])['counting'].sum()
kg = kaggle_data.groupby(['os'])['counting'].sum()
kg.plot(kind = 'bar')
plt.show()




kg = kg[:,np.newaxis]
kg = pd.DataFrame(kg)
kg.columns = ['count']


plt.bar()
plt.figure(figsize=(10,5))
plt.plot(sdt, 'o', color='black')

pd.to_datetime

######################################################

regimentbucketclicksum.plot(kind = 'bar', title = ' by Regiment, Bucket')
plt.ylabel('clicks')
plt.show()
