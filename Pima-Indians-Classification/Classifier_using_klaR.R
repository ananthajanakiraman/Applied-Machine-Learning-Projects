wdat<-read.csv('pima.txt', header=FALSE)
library(klaR)
library(caret)
bigx<-wdat[,-c(9)]
bigy<-as.factor(wdat[,9])
wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)
trax<-bigx[wtd,]
tray<-bigy[wtd]
suppressWarnings(model<-train(trax, tray, 'nb', trControl=trainControl(method='cv', number=10),na.action="na.pass"))
suppressWarnings(teclasses<-predict(model,newdata=bigx[-wtd,],na.action="na.pass"))
print(confusionMatrix(data=teclasses, bigy[-wtd]))
