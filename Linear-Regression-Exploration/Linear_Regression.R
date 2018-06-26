#7.9 - Log-Log plot
brunhild_df <- read.csv("brunhild.txt",sep="\t",header = TRUE)
lm_out <- lm(log(Sulfate)~log(Hours),data = brunhild_df)
plot(log(Sulfate)~log(Hours),data=brunhild_df)
abline(lm_out)

#7.9 - Original coordinates plot
#lm_out_2 <- lm(exp(log(Hours))~exp(log(Sulfate)),data = brunhild_df)
#plot(Hours~Sulfate,data=brunhild_df)
#abline(lm_out_2)
#fit <- exp(predict(lm_out,list(Hours=xx)))

#xx <- seq(0,200,1)
xx <- brunhild_df[,"Hours"]
fit <- exp(lm_out$fitted.values)
plot(Sulfate~Hours,data=brunhild_df)
lines(xx,fit,lty=1)

#7.9 - Plot residual against fitted values
plot(lm_out,1) #log-log plot
orig_resid <- exp(log(brunhild_df[,"Sulfate"])) - exp(lm_out$fitted.values)
plot(exp(lm_out$fitted.values),orig_resid1,xlab = "Fitted",ylab = "Residual", main = "Fitted vs Residual") #Original coordinates

#7.10
physical_df <- read.csv("physical.txt",sep="\t",header = TRUE)
lm_physical <- lm(Mass~(Fore+Bicep+Chest+Neck+Shoulder+Waist+Height+Calf+Thigh+Head),data=physical_df)
plot(lm_physical,1)

physical_df <- cbind.data.frame(physical_df,Mass_crt=(physical_df$Mass ^ (1/3)))
lm_physical_2 <- lm(Mass_crt~(Fore+Bicep+Chest+Neck+Shoulder+Waist+Height+Calf+Thigh+Head),data=physical_df)
plot(lm_physical_2,1)

orig_resid_1 <- physical_df[,"Mass"] - (lm_physical_2$fitted.values)^3
plot((lm_physical_2$fitted.values)^3,orig_resid_1,xlab = "Fitted",ylab = "Residual", main = "Fitted vs Residual")

#7.11
abalone_df <- read.csv("abalone.data",sep=",",header = FALSE,stringsAsFactors = FALSE)
colnames(abalone_df) <- c("Sex","Length","Diameter","Height","Whole_Weight","Shucked_Weight","Viscera_Weight","Shell_Weight","Rings")
abalone_df <- cbind.data.frame(abalone_df,Age=abalone_df[,"Rings"]+1.5)

#a.
lm_abalone <- lm(Age~Length+Diameter+Height+Whole_Weight+Shucked_Weight+Viscera_Weight+Shell_Weight,data=abalone_df)
plot(lm_abalone,1)

#b.
abalone_df[abalone_df$Sex=="M",]$Sex <- 1
abalone_df[abalone_df$Sex=="F",]$Sex <- 0
abalone_df[abalone_df$Sex=="I",]$Sex <- -1
abalone_df$Sex <- factor(abalone_df$Sex)
lm_abalone_b <- lm(Age~Sex+Length+Diameter+Height+Whole_Weight+Shucked_Weight+Viscera_Weight+Shell_Weight,data=abalone_df)
plot(lm_abalone_b,1)

#c.
lm_abalone_log_a <- lm(log(Age)~Length+Diameter+Height+Whole_Weight+Shucked_Weight+Viscera_Weight+Shell_Weight,data=abalone_df)
plot(lm_abalone_log_a,1)

#d.
lm_abalone_log_b <- lm(log(Age)~Sex+Length+Diameter+Height+Whole_Weight+Shucked_Weight+Viscera_Weight+Shell_Weight,data=abalone_df)
plot(lm_abalone_log_b,1)

#f.

cv_fit <- glmnet::cv.glmnet(as.matrix(abalone_df[,2:8]),abalone_df$Age,alpha=0,nfolds = 5)
plot(cv_fit)
#newxx <- abalone_df[,2:8]
#glm_hat <- predict(cv_fit,s=cv_fit$lambda.min,newx=as.matrix(newxx))
#glm_rsq1 <- rsquare(abalone_df$Age,glm_hat)


feature_matrix <- as.matrix(as.numeric(abalone_df[,1]))
feature_matrix <- cbind(feature_matrix,abalone_df[,2:8])
cv_fit <- glmnet::cv.glmnet(as.matrix(feature_matrix),abalone_df$Age,alpha=0,nfolds = 5)
plot(cv_fit)
#newxx <- as.matrix(feature_matrix)
#glm_hat <- predict(cv_fit,s=cv_fit$lambda.min,newx=newxx)
#glm_rsq1 <- rsquare(abalone_df$Age,glm_hat)


cv_fit <- glmnet::cv.glmnet(as.matrix(abalone_df[,2:8]),log(abalone_df$Age),alpha=0,nfolds = 5)
plot(cv_fit)
#newxx <- as.matrix(abalone_df[,2:8])
#glm_hat <- predict(cv_fit,s=cv_fit$lambda.min,newx=newxx)
#glm_rsq1 <- rsquare(log(abalone_df$Age),glm_hat)

cv_fit <- glmnet::cv.glmnet(as.matrix(feature_matrix),log(abalone_df$Age),alpha=0,nfolds = 5)
plot(cv_fit)
#newxx <- as.matrix(feature_matrix)
#glm_hat <- predict(cv_fit,s=cv_fit$lambda.min,newx=newxx)
#glm_rsq1 <- rsquare(log(abalone_df$Age),glm_hat)


rsquare <- function(true, predicted) {
  sse <- sum((predicted - true)^2)
  sst <- sum((true - mean(true))^2)
  rsq <- 1 - sse / sst
  
  # For this post, impose floor...
  if (rsq < 0) rsq <- 0
  
  return (rsq)
}
