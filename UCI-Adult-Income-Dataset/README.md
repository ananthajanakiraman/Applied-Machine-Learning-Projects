**Dataset**

The UC Irvine machine learning data repository hosts a collection of data on adult income, donated by Ronny Kohavi and Barry Becker. You can find this data at https://archive.ics.uci.edu/ml/datasets/Adult For each record, there is a set of continuous attributes, and a class "less than 50K" or "greater than 50K". There are 48842 examples. I used only the continuous attributes (see the description on the web page) and dropped examples where there are missing values of the continuous attributes. I also separated the resulting dataset randomly into 10% validation, 10% test, and 80% training examples.

**SVM Classification using Stochastic Gradient Descent**

I implemented and trained a support vector machine on the data using stochastic gradient descent. I did not use a package to train the classifier but wrote my own code. I ignored the id number, and used the continuous variables as a feature vector. I scale these variables so that each had unit variance. I also searched for an appropriate value of the regularization constant, and tried at least the values [1e-3, 1e-2, 1e-1, 1]. Used a validation set for this search. I used at least 50 epochs of at least 300 steps each. In each epoch, I separated out 50 training examples at random for evaluation (called this the set held out for the epoch). I computed the accuracy of the current classifier on the set held out for the epoch every 30 steps.

Based on the implementation above I produced the following

+ Plot of the accuracy every 30 steps, for each value of the regularization constant.
+ plot of the magnitude of the coefficient vector every 30 steps, for each value of the regularization constant.
+ Estimate of the best value of the regularization constant, together with a brief description of why you believe that is a good value.
+ Your estimate of the accuracy of the best classifier on the 10% test dataset data

