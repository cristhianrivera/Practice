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



################################# Iris dataset
import seaborn as sns
iris = sns.load_dataset('iris')
iris.head()

#%matplotlib inline
import seaborn as sns; sns.set()
sns.pairplot(iris, hue='species', size=2.5);

X_iris = iris.drop('species', axis=1)
y_iris = iris['species']



##########################Simple linear regression with scipy
import matplotlib.pyplot as plt
import numpy as np

rng = np.random.RandomState(42)
x = 10 * rng.rand(50)
y = 2 * x - 1 + rng.randn(50)

plt.figure(figsize=(5,5))
plt.scatter(x, y);


from sklearn.linear_model import LinearRegression
model = LinearRegression(fit_intercept=True)


#modify the x array to have the a consistent shape
X = x[:, np.newaxis]
Y = y[:, np.newaxis] #it still works for y

#apply the model to the data
model.fit(X,y)

##make some predictions 
xfit = np.linspace(-1, 11, num = 50)
Xfit = xfit[:, np.newaxis]
yfit = model.predict(Xfit)

##visualize predictions vs real
plt.scatter(x, y)
plt.plot(xfit, yfit);

#################Naive bayes

from sklearn.model_selection import train_test_split
Xtrain, Xtest, ytrain, ytest = train_test_split(X_iris, y_iris,
                                                random_state=1)

from sklearn.naive_bayes import GaussianNB # 1. choose model class
model = GaussianNB()                       # 2. instantiate model
model.fit(Xtrain, ytrain)                  # 3. fit model to data
y_model = model.predict(Xtest)             # 4. predict on new data

from sklearn.metrics import accuracy_score
accuracy_score(ytest, y_model)


###PCA
from sklearn.decomposition import PCA  # 1. Choose the model class
model = PCA(n_components=2)            # 2. Instantiate the model with hyperparameters
model.fit(X_iris)                      # 3. Fit to data. Notice y is not specified!
X_2D = model.transform(X_iris)         # 4. Transform the data to two dimensions

iris['PCA1'] = X_2D[:, 0]
iris['PCA2'] = X_2D[:, 1]
sns.lmplot("PCA1", "PCA2", hue='species', data=iris, fit_reg=False);


####### gaussian misture models
from sklearn.mixture import GaussianMixture      # 1. Choose the model class
model = GaussianMixture(n_components=3,
            covariance_type='full')  # 2. Instantiate the model with hyperparameters
model.fit(X_iris)                    # 3. Fit to data. Notice y is not specified!
y_gmm = model.predict(X_iris)  

iris['cluster'] = y_gmm
sns.lmplot("PCA1", "PCA2", data=iris, hue='species',
           col='cluster', fit_reg=False);

           
           
















