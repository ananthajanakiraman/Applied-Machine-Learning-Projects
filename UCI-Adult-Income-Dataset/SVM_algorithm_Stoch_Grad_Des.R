#1. Read input files and load the data & labels into a dataframe.

wdat_train <-read.csv('adult.data', header=FALSE,stringsAsFactors = FALSE)
wdat_test <- read.csv('adult.txt',header = FALSE,stringsAsFactors = FALSE)

# 2. Cleanup and Prepare data.

wdat_final <- rbind.data.frame(wdat_train,wdat_test,stringsAsFactors = FALSE)
colnames(wdat_final) <- c("age","workclass","fnlwgt","education","education-num","marital-status","occupation","relationship","race","sex","capital-gain","capital-loss","hours-per-week","native-country","label")
neg_label <- wdat_final[,15]==" <=50K"
pos_label <- wdat_final[,15]==" >50K"
wdat_final[neg_label,15]= -1
wdat_final[pos_label,15]= 1
wdat_final[,c(1,3,5,11,12,13)] <- scale(wdat_final[,c(1,3,5,11,12,13)])
wdat_final_features <- wdat_final[,c(1,3,5,11,12,13)]
wdat_final_labels <- as.numeric(wdat_final[,15])

#3. Split the data as training, validation and test. Training - 80%; Test - 10%; Validation - 10%.

split_data <- createDataPartition(y=wdat_final_labels, p=.9000, list=FALSE)
wdat_final_features_t <- wdat_final_features[split_data,]
wdat_final_labels_t <- wdat_final_labels[split_data]
wdat_final_features_test <- wdat_final_features[-split_data,]
wdat_final_labels_test <- wdat_final_labels[-split_data]

train_val_split <- createDataPartition(y=wdat_final_labels_t, p=.8889, list = FALSE)
wdat_final_features_train <- wdat_final_features_t[train_val_split,]
wdat_final_labels_train <- wdat_final_labels_t[train_val_split]
wdat_final_features_val <- wdat_final_features_t[-train_val_split,]
wdat_final_labels_val <- wdat_final_labels_t[-train_val_split]


#4 a. Convert train dataframe into matrix for generating feature vector.
#4 b. Perform random sampling of feature vector in each step & compute gradient.
#4 c. Initialize estimation parameters, regularizer and step size.
#4 d. Perform validation using the validation set to determine optimal regularizer.
#4 e. Perform evaluation on the held out samples every 30 steps.
#4 f. Compute magnitude of the weight vector every 30 steps.
#4 g. Compute accuracy on the test set.

a_val <- as.vector(c(0,0,0,0,0,0))
lambda_val <- 10
lambda <- 10
b_val <- as.vector(0)
n_val <- 0
a_val_low <- as.vector(c(0,0,0,0,0,0))
train_eval_df <- data.frame()
sumofright_val <- as.numeric(0)
sumofwrong_val <- as.numeric(0)
hold_accuracy_val <- as.numeric(0)

wdat_final_features_val_matrix <- as.matrix(wdat_final_features_val)
wdat_final_labels_val_matrix <- as.matrix(wdat_final_labels_val)

for (m in 1:5) {
  
  lambda_val <- (lambda_val/10)
  #print(lambda_val)
  
  a_val_low <- a_val
  a_val <- as.vector(c(0,0,0,0,0,0))
  b_val <- as.vector(0)
  n_val <- 0
  
  for (l in 1:nrow(wdat_final_features_val)) {
    
    n_val = 1/(0.01 * 2 + 50) #try different values for step size
    
    x_val <- as.vector(wdat_final_features_val_matrix[l,])
    y_val <- wdat_final_labels_val_matrix[l,1]
    
    condition_val <- (y_val * (sum(t(a_val) * x_val) + b_val))
    
    if (condition_val >= 1) {
      a_val = a_val - n_val * (lambda_val * a_val)
    } else {
      a_val = a_val - n_val * ((lambda_val * a_val) - (y_val * x_val))
      b_val = b_val - n_val * y_val * -1
    }  
    
  }
  
  for (k_val in 1:nrow(wdat_final_features_val)) {
    xi_val <- as.vector(wdat_final_features_val_matrix[k_val,])
    predict_label_val = sign(sum(t(a_val) * xi_val) + b_val)
    if (predict_label_val == wdat_final_labels_val_matrix[k_val,1]) {
      sumofright_val = sumofright_val + 1
    } else {
      sumofwrong_val = sumofwrong_val + 1
    }
  }
  
  accuracy_val <- (sumofright_val)/(sumofwrong_val + sumofright_val)

#The below IF condition checks for the size of weight vector and determines the optimal lambda
#  if (sqrt(sum(t(a_val) * a_val)) > sqrt(sum(t(a_val_low) * a_val_low))) {
#    a_val_low <- a_val
#    lambda <- lambda_val
#  }

# Choosing lambda based on accuracy of validtion set - 
  
  if(accuracy_val > hold_accuracy_val)
  {
    lambda <- lambda_val
    hold_accuracy_val <- accuracy_val
  }
  
}

print("===================================")
print(lambda_val)
print("===================================")

#lambda <- 10

#for (z in 1:15) {

#lambda <- lambda/10
a <- as.vector(c(0,0,0,0,0,0))
lambda <- lambda_val #or try different regularizer values 1, 1e-1, 1e-2, 1e-3, 1e-4 etc
b <- as.vector(0)
n <- 0

sumofright <- as.numeric(0)
sumofwrong <- as.numeric(0)
sumofright_eval <- as.numeric(0)
sumofwrong_eval <- as.numeric(0)

wdat_final_features_train_matrix <- as.matrix(wdat_final_features_train)
wdat_final_labels_train_matrix <- as.matrix(wdat_final_labels_train)

wdat_final_features_test_matrix <- as.matrix(wdat_final_features_test)
wdat_final_labels_test_matrix <- as.matrix(wdat_final_labels_test)

for (i in 1:50) {
  
  rownum_eval <- sample(1:nrow(wdat_final_features_train_matrix),50,replace = F)
  wdat_final_features_eval_matrix <- wdat_final_features_train_matrix[rownum_eval,]
  wdat_final_labels_eval_matrix <- as.matrix(wdat_final_labels_train_matrix[rownum_eval,])
  
  for (j in 1:300) {
    
    n = 1/(0.01 * i + 50)
    
    rownum <- sample(1:nrow(wdat_final_features_train_matrix),1,replace = T)
    x <- as.vector(wdat_final_features_train_matrix[rownum,])
    y <- wdat_final_labels_train_matrix[rownum,1]
    
    #Condition formulation : y(t(a).x + b)
    
    condition <- (y * (sum(t(a) * x) + b))
    
    #Setting up the Gradient
    
    if (condition >= 1) {
      a = a - n * (lambda * a)
    } else {
      a = a - n * ((lambda * a) - (y * x))
      b = b - n * y * -1
    }
    
    if (j%%30 == 0) {
      
      for (p in 1:nrow(wdat_final_features_eval_matrix)) {
        
        xi_eval <- as.vector(wdat_final_features_eval_matrix[p,])
        predict_label_eval = sign(sum(t(a) * xi_eval) + b)
        if (predict_label_eval == wdat_final_labels_eval_matrix[p,1]) {
          sumofright_eval = sumofright_eval + 1
        } else {
          sumofwrong_eval = sumofwrong_eval + 1
        }
        
      }
      accuracy_eval <- sumofright_eval/(sumofright_eval + sumofwrong_eval)
      magnitude_of_a <- sqrt(a[1]^2+a[2]^2+a[3]^2+a[4]^2+a[5]^2+a[6]^2)
      #magnitude_of_a <- sqrt(sum(t(a) * a))
      train_eval_df <- rbind.data.frame(train_eval_df,c(i,lambda,accuracy_eval,magnitude_of_a),stringsAsFactors = FALSE)
    } 
    
  }
  
}

colnames(train_eval_df) <- c("epoch","regularizer","accuracy","magnitude")

for (k in 1:nrow(wdat_final_features_test)) {
  xi <- as.vector(wdat_final_features_test_matrix[k,])
  predict_label = sign(sum(t(a) * xi) + b)
  if (predict_label == wdat_final_labels_test_matrix[k,1]) {
    sumofright = sumofright + 1
  } else {
    sumofwrong = sumofwrong + 1
  }
}

accuracy <- (sumofright)/(sumofwrong + sumofright)

print(accuracy)

#}

#5. Plot the magnitude vector every 30 steps in each epoch.

plot(train_eval_df$epoch[train_eval_df$regularizer==0.0001],train_eval_df$magnitude[train_eval_df$regularizer==0.0001],ylim=c(0,3),type = "l",col="red",xlab = "Epoch",ylab = "Magnitude")
lines(train_eval_df$epoch[train_eval_df$regularizer==0.001],train_eval_df$magnitude[train_eval_df$regularizer==0.001],ylim=c(0,3),col="blue")
lines(train_eval_df$epoch[train_eval_df$regularizer==0.01],train_eval_df$magnitude[train_eval_df$regularizer==0.01],ylim=c(0,3),col="dark green")
lines(train_eval_df$epoch[train_eval_df$regularizer==0.1],train_eval_df$magnitude[train_eval_df$regularizer==0.1],ylim=c(0,3),col="orange")
lines(train_eval_df$epoch[train_eval_df$regularizer==1],train_eval_df$magnitude[train_eval_df$regularizer==1],ylim=c(0,3),col="cyan")
legend("topleft","x,y",c("1e-4","1e-3","1e-2","1e-1","1"),lty=c(1,1),lwd=c(1.5,1.5,1.5,1.5,1.5),cex=0.75,col=c("red","blue","dark green","orange","cyan"))

#6. Plot the accuracy computed on evaluation set every 30 steps in each epoch.

plot(train_eval_df$epoch[train_eval_df$regularizer==0.0001],train_eval_df$accuracy[train_eval_df$regularizer==0.0001],ylim=c(0,1),type = "l",col="red",xlab = "Epoch",ylab = "Accuracy")
lines(train_eval_df$epoch[train_eval_df$regularizer==0.001],train_eval_df$accuracy[train_eval_df$regularizer==0.001],ylim=c(0,1),col="blue")
lines(train_eval_df$epoch[train_eval_df$regularizer==0.01],train_eval_df$accuracy[train_eval_df$regularizer==0.01],ylim=c(0,1),col="dark green")
lines(train_eval_df$epoch[train_eval_df$regularizer==0.1],train_eval_df$accuracy[train_eval_df$regularizer==0.1],ylim=c(0,1),col="orange")
lines(train_eval_df$epoch[train_eval_df$regularizer==1],train_eval_df$accuracy[train_eval_df$regularizer==1],ylim=c(0,1),col="cyan")
legend("bottomright","x,y",c("1e-4","1e-3","1e-2","1e-1","1"),lty=c(1,1),lwd=c(1.5,1.5,1.5,1.5,1.5),cex=0.75,col=c("red","blue","dark green","orange","cyan"))
