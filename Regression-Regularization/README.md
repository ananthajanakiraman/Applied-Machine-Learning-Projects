**Datasets**

I used the following datasets for this exploration.

For my exploration of Linear Regression using various regularizers, I used a dataset from the UCI Machine Learning Repository - https://archive.ics.uci.edu/ml/datasets/Geographical+Original+of+Music that gives features of music, and the latitude and longitude from which that music originates. There are actually two versions of this dataset. I used the one with more independent variables that I found more interesting. I ignored outliers did not try to deal with them. I also regarded latitude and longitude as entirely independent.

For Logistic Regression, I used a dataset that gives whether a Taiwanese credit card user defaults against a variety of features hosted in UCI Machine Learning Repository-http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients.

**Linear Regression**

In statistics, linear regression is a linear approach to modelling the relationship between a scalar response (or dependent variable) and one or more explanatory variables (or independent variables). The case of one explanatory variable is called simple linear regression. For more than one explanatory variable, the process is called multiple linear regression. This term is distinct from multivariate linear regression, where multiple correlated dependent variables are predicted, rather than a single scalar variable.

In linear regression, the relationships are modeled using linear predictor functions whose unknown model parameters are estimated from the data. Such models are called linear models. Most commonly, the conditional mean of the response given the values of the explanatory variables (or predictors) is assumed to be an affine function of those values; less commonly, the conditional median or some other quantile is used. Like all forms of regression analysis, linear regression focuses on the conditional probability distribution of the response given the values of the predictors, rather than on the joint probability distribution of all of these variables, which is the domain of multivariate analysis.

**Regularization**

We will discuss the following three regularization methods briefly.

+ L1 Regularization
+ L2 Regularization
+ Elasticnet Regularization

A regression model that uses L1 regularization technique is called Lasso Regression and model which uses L2 is called Ridge Regression. The key difference between these two is the penalty term.

**Ridge regression** adds "squared magnitude" of coefficient as penalty term to the loss function. Here the highlighted part represents L2 regularization element. 

<img src="c1.png">

Here, if lambda is zero then you can imagine we get back OLS. However, if lambda is very large then it will add too much weight and it will lead to under-fitting. Having said that it’s important how lambda is chosen. This technique works very well to avoid over-fitting issue.

**Lasso Regression** (Least Absolute Shrinkage and Selection Operator) adds “absolute value of magnitude” of coefficient as penalty term to the loss function. 

<img src="c2.png">

Again, if lambda is zero then we will get back OLS whereas very large value will make coefficients zero hence it will under-fit.

The key difference between these two techniques is that Lasso shrinks the less important feature’s coefficient to zero thus, removing some feature altogether. So, this works well for feature selection in case we have a huge number of features.

Traditional methods like cross-validation, stepwise regression to handle overfitting and perform feature selection work well with a small set of features but these techniques are a great alternative when we are dealing with a large set of features.

**Elasticnet regression** is a regularized regression method that linearly combines the L1 and L2 penalties of the lasso and ridge methods.
