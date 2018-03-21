# -*- coding: utf-8 -*-
"""
Created on Wed Mar 21 15:39:20 2018

@author: a688291
"""

import numpy as np

name = ['Alice', 'Bob', 'Cathy', 'Doug']
age = [25, 45, 37, 19]
weight = [55.0, 85.5, 68.0, 61.5]

# Use a compound data type for structured arrays
data = np.zeros(4, dtype={'names':('name', 'age', 'weight'),
                          'formats':('U10', 'i4', 'f8')})
print(data.dtype)

#fill in the array
data['name'] = name
data['age'] = age
data['weight'] = weight

#some conditions
data[data['age'] < 30]['name']



import pandas as pd

data = pd.Series([0.25, 0.5, 0.75, 1.0])
data.index
data.values

##Series as specialized dictionary

population_dict = {'California': 38332521,
                   'Texas': 26448193,
                   'New York': 19651127,
                   'Florida': 19552860,
                   'Illinois': 12882135}
population = pd.Series(population_dict)
population['California':'Illinois']
population[0:3]


##dataframe as generalized numpy array
area_dict = {'California': 423967, 'Texas': 695662, 'New York': 141297,
             'Florida': 170312, 'Illinois': 149995, 'Pensilvania':875445 }
area = pd.Series(area_dict)

states = pd.DataFrame({'population': population,
                       'area': area})
states.index
states.columns
states['population']

#operations with indexes
indA = pd.Index([1, 3, 5, 7, 9])
indB = pd.Index([2, 3, 5, 7, 11])

indA & indB

indA | indB

data = pd.Series(['a', 'b', 'c'], index=[1, 3, 5])

data[1]# explicit index when indexing

data[1:3]# implicit index when slicing

data.loc[1] #explicit indexing
data.loc[1:3]

data.iloc[1] #implicit indexing
data.iloc[1:3]


### 
states.keys()
list(states.items())



##### working with data
rng = np.random.RandomState(42)
ser = pd.Series(rng.randint(0, 10, 4))

df = pd.DataFrame(rng.randint(0, 10, (3, 4)),
                  columns=['A', 'B', 'C', 'D'])


np.sin(df * np.pi / 4)

A = pd.DataFrame(rng.randint(0, 20, (2, 2)),
                 columns=list('AB'))
B = pd.DataFrame(rng.randint(0, 10, (3, 3)),
                 columns=list('BAC'))
A + B

fill = A.stack().mean()
A.add(B, fill_value=fill)



































