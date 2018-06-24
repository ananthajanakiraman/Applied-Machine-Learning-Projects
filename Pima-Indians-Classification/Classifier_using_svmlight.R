rm(list=ls())
wdat<-read.csv('pima.txt', header=FALSE)
library(klaR)
library(caret)
bigx<-wdat[,-c(9)]
bigy<-as.factor(wdat[,9])
wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)
svm<-svmlight(bigx[wtd,], bigy[wtd], pathsvm='/Users/anantha/svm_light_osx.8.4_i7/')
labels<-predict(svm, bigx[-wtd,])
foo<-labels$class
teste <- sum(foo==bigy[-wtd])/(sum(foo==bigy[-wtd])+sum(!(foo==bigy[-wtd])))
