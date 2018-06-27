library(MASS)
music_df <- read.csv("default_plus_chromatic_features_1059_tracks.txt",sep=",",header = FALSE)
colnames(music_df)[117] <- "lat"
colnames(music_df)[118] <- "long"
music_lat_df <- music_df[,c(colnames(music_df)[1:116],"lat")]
music_lon_df <- music_df[,c(colnames(music_df)[1:116],"long")]

#1. Plot regular regression for response variables - Latitude & Longitude

lm_lat <- lm(formula = lat ~ ., data = music_lat_df)
plot(lm_lat)

lm_lon <- lm(formula = long ~ ., data = music_lon_df)
plot(lm_lon)

music_lat_df <- cbind.data.frame(music_lat_df,lat_adjusted=music_lat_df$lat+90)
music_lon_df <- cbind.data.frame(music_lon_df,lon_adjusted=music_lon_df$long+180)

#2. Box Cox transform Latitude and regress on transformed data

boxcox_trans <- boxcox( lat_adjusted ~ . - lat, lambda = seq(-5, 5, 1/10),data = music_lat_df)
lambda <- boxcox_trans$x
loglik <- boxcox_trans$y
bc = cbind(lambda,loglik)
bc = bc[order(-loglik),]
lambda_lat=as.numeric(bc[1,1])

music_lat_df <- cbind.data.frame(music_lat_df,lat_bc=((music_lat_df$lat_adjusted ^ lambda_lat)-1)/lambda_lat)
lm_lat_bc <- lm(formula = lat_bc ~ . - lat - lat_adjusted, data = music_lat_df)
plot(lm_lat_bc)

#3. Box Cox transform Longitude and regress on transformed data

boxcox_lon <- boxcox( lon_adjusted ~ . - long, lambda = seq(-5, 5, 1/10),data = music_lon_df)
lambda <- boxcox_lon$x
loglik <- boxcox_lon$y
bc_lon = cbind(lambda,loglik)
bc_lon = bc_lon[order(-loglik),]
lambda_lon=as.numeric(bc_lon[1,1])

music_lon_df <- cbind.data.frame(music_lon_df,lon_bc=((music_lon_df$lon_adjusted ^ lambda_lon)-1)/lambda_lon)
lm_lon_bc <- lm(formula = lon_bc ~ . - long - lon_adjusted, data = music_lon_df)
plot(lm_lon_bc)

#4. Perform Inverse BoxCox to original coordinates and calculate mean squared value 

invBoxCox <- function(y, lambda) {
  if (lambda == 0) { exp(y) } else  { (lambda*y + 1)^(1/lambda) }
}

#fit_lat <- predict(lm_lat_bc,music_lat_df[,1:118])
fit_lat <- invBoxCox(lm_lat_bc$fitted.values,lambda_lat)
fit_lat <- fit_lat-90
postResample(fit_lat,music_lat_df$lat_adjusted)

fit_lon <- invBoxCox(lm_lon_bc$fitted.values,lambda_lon)
fit_lon <- fit_lon-180
postResample(fit_lon,music_lon_df$lon_adjusted)

#5. Glmnet - Ridge, Lasso and elasticnet
#coef(cv.ridge, s=cv.ridge$lambda.min)

rsquare <- function(true, predicted) {
  sse <- sum((predicted - true)^2)
  sst <- sum((true - mean(true))^2)
  rsq <- 1 - sse / sst
  
  # For this post, impose floor...
  if (rsq < 0) rsq <- 0
  
  return (rsq)
}

#Unregularized - Latitude
music_lat_df1 <- music_lat_df[,1:117]
cv.unreg <- glm(lat ~ .,data=music_lat_df1)
glm_yhat_unreg <- predict(cv.unreg,newdata=music_lat_df1[,1:116],type="response")
fit.delta <- cv.glm(music_lat_df1,cv.unreg,K=5)$delta
glm_rsq_unreg  <- rsquare(music_lat_df1$lat, glm_yhat_unreg)
print(glm_rsq_unreg)
print(fit.delta)
print(length(coefficients(cv.unreg))-1)
par (mfrow=c(2,2))
plot(cv.unreg)

#Unregularized - Longitude
music_lon_df1 <- music_lon_df[,1:117]
cv.unreg <- glm(long ~ .,data=music_lon_df1)
glm_yhat_unreg <- predict(cv.unreg,newdata=music_lon_df1[,1:116],type="response")
fit.delta <- cv.glm(music_lon_df1,cv.unreg,K=5)$delta
glm_rsq_unreg  <- rsquare(music_lon_df1$long, glm_yhat_unreg)
print(glm_rsq_unreg)
print(fit.delta)
print(length(coefficients(cv.unreg))-1)
par (mfrow=c(2,2))
plot(cv.unreg)

#L2 regularized - Latitude
cv.ridge <- glmnet::cv.glmnet(as.matrix(music_lat_df[,1:116]), music_lat_df$lat, alpha=0, nfolds = 5)
opt_lambda_ridge  <- cv.ridge$lambda.min  
glm_fit_ridge     <- cv.ridge$glmnet.fit
plot(cv.ridge)
glm_yhat_ridge <- predict(glm_fit_ridge, s = opt_lambda_ridge, newx = as.matrix(music_lat_df[,1:116]))
glm_rsq_ridge  <- rsquare(music_lat_df$lat, glm_yhat_ridge)
print(glm_rsq_ridge)
plot(cv.ridge$glmnet.fit, "lambda", label=TRUE)

mse.min <- cv.ridge$cvm[cv.ridge$lambda == cv.ridge$lambda.min]
print(mse.min)
print(opt_lambda_ridge)
print(nnzero(coef(cv.ridge,s=cv.ridge$lambda.min))-1)

#L2 regularized - Longitude
cv.ridge <- glmnet::cv.glmnet(as.matrix(music_lon_df[,1:116]), music_lon_df$long, alpha=0, nfolds = 5)
opt_lambda_ridge  <- cv.ridge$lambda.min  
glm_fit_ridge     <- cv.ridge$glmnet.fit
plot(cv.ridge)
glm_yhat_ridge <- predict(glm_fit_ridge, s = opt_lambda_ridge, newx = as.matrix(music_lon_df[,1:116]))
glm_rsq_ridge  <- rsquare(music_lon_df$long, glm_yhat_ridge)
print(glm_rsq_ridge)
plot(cv.ridge$glmnet.fit, "lambda", label=TRUE)

mse.min <- cv.ridge$cvm[cv.ridge$lambda == cv.ridge$lambda.min]
print(mse.min)
print(opt_lambda_ridge)
print(nnzero(coef(cv.ridge,s=cv.ridge$lambda.min))-1)

#L1 regularized - Latitude
cv.lasso <- glmnet::cv.glmnet(as.matrix(music_lat_df[,1:116]), music_lat_df$lat, alpha=1, nfolds = 5)
opt_lambda_lasso  <- cv.lasso$lambda.min  
glm_fit_lasso     <- cv.lasso$glmnet.fit
plot(cv.lasso)
glm_yhat_lasso <- predict(glm_fit_lasso, s = opt_lambda_lasso, newx = as.matrix(music_lat_df[,1:116]))
glm_rsq_lasso  <- rsquare(music_lat_df$lat, glm_yhat_lasso)
print(glm_rsq_lasso)
plot(cv.lasso$glmnet.fit, "lambda", label=TRUE)

mse.min <- cv.lasso$cvm[cv.lasso$lambda == cv.lasso$lambda.min]
print(mse.min)
print(opt_lambda_lasso)
print(nnzero(coef(cv.lasso,s=cv.lasso$lambda.min))-1)

#L1 regularized - Longitude
cv.lasso <- glmnet::cv.glmnet(as.matrix(music_lon_df[,1:116]), music_lon_df$long, alpha=1, nfolds = 5)
opt_lambda_lasso  <- cv.lasso$lambda.min  
glm_fit_lasso     <- cv.lasso$glmnet.fit
plot(cv.lasso)
glm_yhat_lasso <- predict(glm_fit_lasso, s = opt_lambda_lasso, newx = as.matrix(music_lon_df[,1:116]))
glm_rsq_lasso  <- rsquare(music_lon_df$long, glm_yhat_lasso)
print(glm_rsq_lasso)
plot(cv.lasso$glmnet.fit, "lambda", label=TRUE)

mse.min <- cv.lasso$cvm[cv.lasso$lambda == cv.lasso$lambda.min]
print(mse.min)
print(opt_lambda_lasso)
print(nnzero(coef(cv.lasso,s=cv.lasso$lambda.min))-1)

#elasticnet regularized - Latitude
cv.enet_0.2 <- glmnet::cv.glmnet(as.matrix(music_lat_df[,1:116]), music_lat_df$lat, alpha=0.2, nfolds = 5)
opt_lambda_enet  <- cv.enet_0.2$lambda.min  
glm_fit_enet     <- cv.enet_0.2$glmnet.fit
glm_yhat_enet <- predict(glm_fit_enet, s = opt_lambda_enet, newx = as.matrix(music_lat_df[,1:116]))
glm_rsq_enet <- rsquare(music_lat_df$lat, glm_yhat_enet)
print(glm_rsq_enet)

mse.min <- cv.enet_0.2$cvm[cv.enet_0.2$lambda == cv.enet_0.2$lambda.min]
print(mse.min)
print(opt_lambda_enet)
print(nnzero(coef(cv.enet_0.2,s=cv.enet_0.2$lambda.min))-1)

cv.enet_0.5 <- glmnet::cv.glmnet(as.matrix(music_lat_df[,1:116]), music_lat_df$lat, alpha=0.5, nfolds = 5)
opt_lambda_enet  <- cv.enet_0.5$lambda.min  
glm_fit_enet     <- cv.enet_0.5$glmnet.fit
glm_yhat_enet <- predict(glm_fit_enet, s = opt_lambda_enet, newx = as.matrix(music_lat_df[,1:116]))
glm_rsq_enet <- rsquare(music_lat_df$lat, glm_yhat_enet)
print(glm_rsq_enet)

mse.min <- cv.enet_0.5$cvm[cv.enet_0.5$lambda == cv.enet_0.5$lambda.min]
print(mse.min)
print(opt_lambda_enet)
print(nnzero(coef(cv.enet_0.5,s=cv.enet_0.5$lambda.min))-1)

cv.enet_0.8 <- glmnet::cv.glmnet(as.matrix(music_lat_df[,1:116]), music_lat_df$lat, alpha=0.8, nfolds = 5)
opt_lambda_enet  <- cv.enet_0.8$lambda.min  
glm_fit_enet     <- cv.enet_0.8$glmnet.fit
print(opt_lambda_enet)
glm_yhat_enet <- predict(glm_fit_enet, s = opt_lambda_enet, newx = as.matrix(music_lat_df[,1:116]))
glm_rsq_enet <- rsquare(music_lat_df$lat, glm_yhat_enet)
print(glm_rsq_enet)

mse.min <- cv.enet_0.8$cvm[cv.enet_0.8$lambda == cv.enet_0.8$lambda.min]
print(mse.min)
print(opt_lambda_enet)
print(nnzero(coef(cv.enet_0.8,s=cv.enet_0.8$lambda.min))-1)

par (mfrow=c(2,2))
plot (cv.enet_0.2) ;
legend( "top" , legend="alpha=0.2", lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5)
plot (cv.enet_0.5)
legend( "top" , legend="alpha =0.5",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5) ;
plot ( cv.enet_0.8 )
legend( "top", legend="alpha=0.8",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5)
plot ( log ( cv.enet_0.2$lambda ) , cv.enet_0.2$cvm , pch =10, col="red" ,
        xlab="log(Lambda )", ylab=cv.enet_0.2$name )
points ( log ( cv.enet_0.5$lambda ) , cv.enet_0.5$cvm , pch =10, col="grey")
points ( log ( cv.enet_0.8$lambda ) , cv.enet_0.8$cvm , pch=10, col= "blue")
legend( "topleft" ,
       legend=c ( "alpha=0.2" , "alpha =0.5" , "alpha=0.8" ) ,
       pch =10, col=c ( "red","grey","blue" ),cex=0.5 )

par (mfrow=c(2,2))
plot (cv.enet_0.2$glmnet.fit, "lambda", label=TRUE) ;
legend( "top" , legend="alpha=0.2", lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5)
plot (cv.enet_0.5$glmnet.fit, "lambda", label=TRUE)
legend( "top" , legend="alpha =0.5",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5) ;
plot (cv.enet_0.8$glmnet.fit, "lambda", label=TRUE)
legend( "top", legend="alpha=0.8",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5)

#elasticnet regularized - Longitude
cv.enet_0.2 <- glmnet::cv.glmnet(as.matrix(music_lon_df[,1:116]), music_lon_df$long, alpha=0.2, nfolds = 5)
opt_lambda_enet  <- cv.enet_0.2$lambda.min  
glm_fit_enet     <- cv.enet_0.2$glmnet.fit
glm_yhat_enet <- predict(glm_fit_enet, s = opt_lambda_enet, newx = as.matrix(music_lon_df[,1:116]))
glm_rsq_enet <- rsquare(music_lon_df$long, glm_yhat_enet)
print(glm_rsq_enet)

mse.min <- cv.enet_0.2$cvm[cv.enet_0.2$lambda == cv.enet_0.2$lambda.min]
print(mse.min)
print(opt_lambda_enet)
print(nnzero(coef(cv.enet_0.2,s=cv.enet_0.2$lambda.min))-1)

cv.enet_0.5 <- glmnet::cv.glmnet(as.matrix(music_lon_df[,1:116]), music_lon_df$long, alpha=0.5, nfolds = 5)
opt_lambda_enet  <- cv.enet_0.5$lambda.min  
glm_fit_enet     <- cv.enet_0.5$glmnet.fit
print(opt_lambda_enet)
glm_yhat_enet <- predict(glm_fit_enet, s = opt_lambda_enet, newx = as.matrix(music_lon_df[,1:116]))
glm_rsq_enet <- rsquare(music_lon_df$long, glm_yhat_enet)
print(glm_rsq_enet)

mse.min <- cv.enet_0.5$cvm[cv.enet_0.5$lambda == cv.enet_0.5$lambda.min]
print(mse.min)
print(opt_lambda_enet)
print(nnzero(coef(cv.enet_0.5,s=cv.enet_0.5$lambda.min))-1)

cv.enet_0.8 <- glmnet::cv.glmnet(as.matrix(music_lon_df[,1:116]), music_lon_df$long, alpha=0.8, nfolds = 5)
opt_lambda_enet  <- cv.enet_0.8$lambda.min  
glm_fit_enet     <- cv.enet_0.8$glmnet.fit
print(opt_lambda_enet)
glm_yhat_enet <- predict(glm_fit_enet, s = opt_lambda_enet, newx = as.matrix(music_lon_df[,1:116]))
glm_rsq_enet <- rsquare(music_lon_df$long, glm_yhat_enet)
print(glm_rsq_enet)

mse.min <- cv.enet_0.8$cvm[cv.enet_0.8$lambda == cv.enet_0.8$lambda.min]
print(mse.min)
print(opt_lambda_enet)
print(nnzero(coef(cv.enet_0.8,s=cv.enet_0.8$lambda.min))-1)

par (mfrow=c(2,2))
plot (cv.enet_0.2) ;
legend( "top" , legend="alpha=0.2", lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5 )
plot (cv.enet_0.5)
legend( "top" , legend="alpha =0.5",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5 ) ;
plot ( cv.enet_0.8 )
legend( "top", legend="alpha=0.8",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5 )
plot ( log ( cv.enet_0.2$lambda ) , cv.enet_0.2$cvm , pch =19, col="red" ,
       xlab="log(Lambda )", ylab=cv.enet_0.2$name )
points ( log ( cv.enet_0.5$lambda ) , cv.enet_0.5$cvm , pch =19, col="grey")
points ( log ( cv.enet_0.8$lambda ) , cv.enet_0.8$cvm , pch=19, col= "blue")
legend( "topleft" ,
        legend=c ( "alpha=0.2" , "alpha =0.5" , "alpha=0.8" ) ,
        pch =19, col=c ( "red","grey","blue" ),cex=0.5  )

par (mfrow=c(2,2))
plot (cv.enet_0.2$glmnet.fit, "lambda", label=TRUE) ;
legend( "top" , legend="alpha=0.2", lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5)
plot (cv.enet_0.5$glmnet.fit, "lambda", label=TRUE)
legend( "top" , legend="alpha =0.5",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5) ;
plot (cv.enet_0.8$glmnet.fit, "lambda", label=TRUE)
legend( "top", legend="alpha=0.8",lty=1:2, col=2:3, adj=c(0,0.6),cex=0.5)

#6. Logistic Regression
credit_card_df <- read.csv("credit_card.csv",sep=",",header = TRUE)
final_labels <- as.factor(credit_card_df[,"Y"])
split_data <- createDataPartition(y=final_labels, p=.8000, list=FALSE)
credit_card_train_df <- credit_card_df[split_data,]
y_train <- final_labels[split_data]
credit_card_test_df <- credit_card_df[-split_data,]
y_test <- final_labels[-split_data]
credit_card_train_df[,24] <- as.factor(credit_card_train_df[,24])
credit_card_test_df[,24] <- as.factor(credit_card_test_df[,24])
credit_card_train_matrix <- as.matrix(credit_card_train_df[,1:23])
credit_card_test_matrix <- as.matrix(credit_card_test_df[,1:23])

mod.glm <- glm(Y ~ . ,family=binomial,data=credit_card_train_df)
model2 <- step(mod.glm,data=credit_card_train_df)
cv.fit.lm <- predict(model2,newdata=credit_card_test_df,type="response")
fit.delta <- (cv.glm(credit_card_train_df,model2,K=5))$delta
cv.fit.lm <- round(cv.fit.lm,2)
cv.fit.lm.pred <- cv.fit.lm
cv.fit.lm.pred[cv.fit.lm.pred<0.5] <- 0
cv.fit.lm.pred[cv.fit.lm.pred>=0.5] <- 1
cv.fit.test.err <- (1-sum(y_test==cv.fit.lm.pred)/length(cv.fit.lm.pred))
print(length(coefficients(model2))-1)

mod_0.0 <- cv.glmnet(credit_card_train_matrix,y_train,family="binomial",type.measure="mse",alpha=0,nfolds = 5)
plot(mod_0.0)
cv.fit.lm.0 <- predict(mod_0.0,credit_card_test_matrix,type="class",s=mod_0.0$lambda.min)
cv.fit.se.0 <- predict(mod_0.0,credit_card_test_matrix,type="class",s=mod_0.0$lambda.1se)
nmright.0 <- sum(y_test==cv.fit.lm.0)
errratem.0 <- (1-nmright.0/nrow(cv.fit.lm.0))
n1right.0 <- sum(y_test==cv.fit.se.0)
errrate1.0 <- (1-n1right.0/nrow(cv.fit.se.0))
mse.min <- mod_0.0$cvm[mod_0.0$lambda == mod_0.0$lambda.min]
print(mse.min)
print(nnzero(coef(mod_0.0,s=mod_0.0$lambda.min))-1)
cat("lambda.min : ",mod_0.0$lambda.min,"\n","lambda.1se : ",mod_0.0$lambda.1se)

mod_1 <- cv.glmnet(credit_card_train_matrix,y_train,family="binomial",type.measure="mse",alpha=1,nfolds = 5)
plot(mod_1)
cv.fit.lm.1 <- predict(mod_1,credit_card_test_matrix,type="class",s=mod_1$lambda.min)
cv.fit.se.1 <- predict(mod_1,credit_card_test_matrix,type="class",s=mod_1$lambda.1se)
nmright.1 <- sum(y_test==cv.fit.lm.1)
errratem.1 <- (1-nmright.1/nrow(cv.fit.lm.1))
n1right.1 <- sum(y_test==cv.fit.se.1)
errrate1.1 <- (1-n1right.1/nrow(cv.fit.se.1))
mse.min <- mod_1$cvm[mod_1$lambda == mod_1$lambda.min]
print(mse.min)
print(nnzero(coef(mod_1,s=mod_1$lambda.min))-1)
cat("lambda.min : ",mod_1$lambda.min,"\n","lambda.1se : ",mod_1$lambda.1se)

mod_0.2 <- cv.glmnet(credit_card_train_matrix,y_train,family="binomial",type.measure="mse",alpha=0.2,nfolds = 5)
plot(mod_0.2)
cv.fit.lm.2 <- predict(mod_0.2,credit_card_test_matrix,type="class",s=mod_0.2$lambda.min)
cv.fit.se.2 <- predict(mod_0.2,credit_card_test_matrix,type="class",s=mod_0.2$lambda.1se)
nmright.2 <- sum(y_test==cv.fit.lm.2)
errratem.2 <- (1-nmright.2/nrow(cv.fit.lm.2))
n1right.2 <- sum(y_test==cv.fit.se.2)
errrate1.2 <- (1-n1right.2/nrow(cv.fit.se.2))
mse.min <- mod_0.2$cvm[mod_0.2$lambda == mod_0.2$lambda.min]
print(mse.min)
print(nnzero(coef(mod_0.2,s=mod_0.2$lambda.min))-1)
cat("lambda.min : ",mod_0.2$lambda.min,"\n","lambda.1se : ",mod_0.2$lambda.1se)

mod_0.5 <- cv.glmnet(credit_card_train_matrix,y_train,family="binomial",type.measure="mse",alpha=0.5,nfolds = 5)
plot(mod_0.5)
cv.fit.lm.5 <- predict(mod_0.5,credit_card_test_matrix,type="class",s=mod_0.5$lambda.min)
cv.fit.se.5 <- predict(mod_0.5,credit_card_test_matrix,type="class",s=mod_0.5$lambda.1se)
nmright.5 <- sum(y_test==cv.fit.lm.5)
errratem.5 <- (1-nmright.5/nrow(cv.fit.lm.5))
n1right.5 <- sum(y_test==cv.fit.se.5)
errrate1.5 <- (1-n1right.5/nrow(cv.fit.se.5))
mse.min <- mod_0.5$cvm[mod_0.5$lambda == mod_0.5$lambda.min]
print(mse.min)
print(nnzero(coef(mod_0.5,s=mod_0.5$lambda.min))-1)
cat("lambda.min : ",mod_0.5$lambda.min,"\n","lambda.1se : ",mod_0.5$lambda.1se)

mod_0.8 <- cv.glmnet(credit_card_train_matrix,y_train,family="binomial",type.measure="mse",alpha=0.8,nfolds = 5)
plot(mod_0.8)
cv.fit.lm.8 <- predict(mod_0.8,credit_card_test_matrix,type="class",s=mod_0.8$lambda.min)
cv.fit.se.8 <- predict(mod_0.8,credit_card_test_matrix,type="class",s=mod_0.8$lambda.1se)
nmright.8 <- sum(y_test==cv.fit.lm.8)
errratem.8 <- (1-nmright.8/nrow(cv.fit.lm.8))
n1right.8 <- sum(y_test==cv.fit.se.8)
errrate1.8 <- (1-n1right.8/nrow(cv.fit.se.8))
mse.min <- mod_0.8$cvm[mod_0.8$lambda == mod_0.8$lambda.min]
print(mse.min)
print(nnzero(coef(mod_0.8,s=mod_0.8$lambda.min))-1)
cat("lambda.min : ",mod_0.8$lambda.min,"\n","lambda.1se : ",mod_0.8$lambda.1se)
