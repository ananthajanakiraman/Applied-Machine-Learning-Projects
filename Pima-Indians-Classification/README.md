**Datasets:**

Dataset - [http://archive.ics.uci.edu/ml/datasets/Pima+Indians+Diabetes](http://archive.ics.uci.edu/ml/datasets/Pima+Indians+Diabetes)

The UC Irvine machine learning data repository hosts a famous collection of data on whether a patient has diabetes (the Pima Indians dataset), originally owned by the National Institute of Diabetes and Digestive and Kidney Diseases and donated by Vincent Sigillito. You can find this data at http://archive.ics.uci.edu/ml/datasets/Pima+Indians+Diabetes. Look over the site and check the description of the data. In the "Data Folder" directory, the primary file needed is named "pima-indians-diabetes.data". This data has a set of attributes of patients, and a categorical variable telling whether the patient is diabetic or not. For several attributes in this data set, a value of 0 may indicate a missing value of the variable.

**References:**

Prof. David Forsyth - http://luthuli.cs.uiuc.edu/~daf/courses/AML-18/learning-book-19-April-18.pdf

For Random Forest I referred to random forest tutorial in [https://github.com/h2oai/h2o-tutorials/tree/master/tutorials/gbm-randomforest](https://github.com/h2oai/h2o-tutorials/tree/master/tutorials/gbm-randomforest)

I used the following R packages for Homework1 &amp; Homework2 – e1071, caret, klaR, h2o, imager, stats.

**Naive Bayes using Normal Distribution**

Built a straight forward implementation of Naive Bayes classifier to classify this data set. I used 20% of the data for evaluation and the other 80% for training. There are a total of 768 data-points. I used normal distribution to model each of the class-conditional distributions. I wrote this classifier myself and did not use any package.

Reporting below the accuracy of the classifier on the 20% evaluation data without any improvement or tuning, where accuracy is the number of correct predictions as a fraction of total predictions.

Accuracy on 20% - Naïve Bayes using Normal Distribution

[1] 0.6666667 0.6299020 0.6740196 0.6584967 0.6560458 0.6887255 0.7230392 0.6576797
[9] 0.6462418 0.6307190

**Naive Bayes using Normal Distribution with special handling**

Adjusted the previous implementation so that, for attribute 3 (Diastolic blood pressure), attribute 4 (Triceps skin fold thickness), attribute 6 (Body mass index), and attribute 8 (Age), it regards a value of 0 as a missing value when estimating the class-conditional distributions, and the posterior. R uses a special number NA to flag a missing value. Most functions handle this number in special, but sensible, ways; but you'll need to do a bit of looking at manuals to check. Reporting the accuracy of the classifier on the 20% that was held out for evaluation.

Accuracy on 20% - Naïve Bayes using Normal Distribution but with missing values replaced to NA.

[1] 0.6321839 0.6806649 0.6926445 0.6803136 0.7008696 0.6362840 0.6530078 0.6362840
[9] 0.6701571 0.6511832

**Naive Bayes implementation using KlaR and caret packages**

Then I used the caret and klaR packages to build a naive bayes classifier for this data, assuming that no attribute has a missing value. The caret package does cross-validation and can be used to hold out data. I performed a 10-fold cross-validation - train (features, labels, classifier, trControl=trainControl(method='cv',number=10))

The klaR package can estimate class-conditional densities using a density estimation procedure. I used arguments in the combination of caret and klaR to handle missing values and reporting the accuracy of the classifier below on the held out 20% data.

Accuracy on 20% - Naïve Bayes using caret and KlaR (Accuracy is highlighted below)

Confusion Matrix and Statistics
_______________________________

                     Reference

         Prediction  0  1

                  0 87 20

                  1 13 33

                **Accuracy : 0.7843**

                    95% CI : (0.7106, 0.8466)

       No Information Rate : 0.6536

    P-Value [Acc &gt; NIR] : 0.0003018

                     Kappa : 0.5084

      Mcnemar Test P-Value : 0.2962699

               Sensitivity : 0.8700

               Specificity : 0.6226

            Pos Pred Value : 0.8131

            Neg Pred Value : 0.7174

                Prevalence : 0.6536

            Detection Rate : 0.5686

      Detection Prevalence : 0.6993

         Balanced Accuracy : 0.7463

          &#39;Positive&#39; Class : 0

**SVM classification using svmlight package**

Then I installed SVMLight, which you can find at http://svmlight.joachims.org, via the interface in klaR (look for svmlight in the manual) to train and evaluate an SVM to classify this data. For training the model, I used: svmlight (features, labels, pathsvm)

There is no need to understand much about SVM's to do this but in my next project I attempted to implement a SVM classifier from the scratch. I did NOT substitute NA values for zeros for attributes 3, 4, 6, and 8. Using the predict function in R, reporting the accuracy of the classifier on the held out 20%

Note: If there is trouble invoking svmlight from within R Studio, make sure your svmlight executable directory is added to the system path. Here are some instructions about editing your system path on various operating systems: https://www.java.com/en/download/help/path.xml. R Studio will need to be restarted (or possibly restart your computer) afterwards for the change to take effect.

Accuracy on 20% - Train and Evaluate SVM to classify the Pima Indians Dataset

[1] 0.7385621
