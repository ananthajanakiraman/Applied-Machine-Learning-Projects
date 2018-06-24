##############################################################################################
#Used the dataframes created from the earlier run for Naive Bayes Normal distribution        #
##############################################################################################
#This code is specifically for untouched image dataset with a 28 x 28 bounding box           #
##############################################################################################

training_work_1 <- as.data.frame(ifelse(training[,1:784] > 127,"yes","no"),stringAsFactor = TRUE)
training_work_1 <- cbind.data.frame(training_work_1,y=training[,785])
test_work_1 <- as.data.frame(ifelse(test[,1:784] > 0,"yes","no"),stringAsFactor = TRUE,levels=c("yes","no"))
test_work_1 <- cbind.data.frame(test_work_1,y=test[,785])
model_1 <- naiveBayes(y ~ ., data = training_work_1)
predict(model_1, test_work_1[1:100,])
predict(model_1, test_work_1[1:100,], type = "raw")
pred_1 <- predict(model_1, test_work_1)
table(pred_1, test_work_1$y)
confusionMatrix(pred_1,test_work_1$y)

########################################################################################################
#Took a copy of  the dataframes created from the earlier run for Naive Bayes Normal distribution       #
#############################################################################################################
#This code is specifically for untouched image dataset with a 20 x 20 bounding box - Bernoulli distribution #
#############################################################################################################

training_work_2 <- as.data.frame(ifelse(training2[,1:400] > 127,"yes","no"),stringAsFactor = TRUE)
training_work_2 <- cbind.data.frame(training_work_2,y=training2[,401])
test_work_2 <- as.data.frame(ifelse(test[,1:400] > 0,"yes","no"),stringAsFactor = TRUE)
test_work_2 <- cbind.data.frame(test_work_2,y=test2[,401])
model_2 <- naiveBayes(y ~ ., data = training_work_2)
predict(model_2, test_work_2[1:100,])
predict(model_2, test_work_2[1:100,], type = "raw")
pred_2 <- predict(model_2, test_work_2)
table(pred_2, test_work_2$y)
confusionMatrix(pred_2,test_work_2$y)

#############################################################################################################
#Took a copy of  the dataframes created from the earlier run for Naive Bayes Normal distribution            #
#############################################################################################################
#This code is specifically for stretched image dataset with a 20 x 20 bounding box - Bernoulli distribution #
#############################################################################################################

training_work <- as.data.frame(ifelse(training3[,1:400] > 127,"yes","no"),stringAsFactor = TRUE)
training_work <- cbind.data.frame(training_work,y=training3[,401])
test_work <- as.data.frame(ifelse(test3[,1:400] > 0,"yes","no"),stringAsFactor = TRUE)
test_work <- cbind.data.frame(test_work,y=test3[,401])
model <- naiveBayes(y ~ ., data = training_work)
predict(model, test_work[1:100,])
predict(model, test_work[1:100,], type = "raw")
pred <- predict(model, test_work)
table(pred, test_work$y)
confusionMatrix(pred,test_work$y)
