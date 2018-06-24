wdat<-read.csv('pima.txt', header=FALSE)
ptrlog <- data.frame()
ntrlog <- data.frame()
ptelog <- data.frame()
ntelog <- data.frame()
bigx<-wdat[,-c(9)]
bigy<-wdat[,9]
nbx<-bigx
for (i in c(3, 5, 6, 8))
{vw<-bigx[, i]==0
nbx[vw, i]=NA
}
trscore<-array(dim=10)
tescore<-array(dim=10)
for (wi in 1:10) {
  wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)
  ntrbx<-nbx[wtd, ]
  ntrby<-bigy[wtd]
  trposflag<-ntrby>0
  ptregs<-ntrbx[trposflag, ]
  ntregs<-ntrbx[!trposflag,]
  ntebx<-nbx[-wtd, ]
  nteby<-bigy[-wtd]
  ptrmean<-sapply(ptregs, mean, na.rm=TRUE)
  ntrmean<-sapply(ntregs, mean, na.rm=TRUE)
  ptrsd<-sapply(ptregs, sd, na.rm=TRUE)
  ntrsd<-sapply(ntregs, sd, na.rm=TRUE)
  
  for(j in 1:length(ntrbx)) {
    for(i in 1:nrow(ntrbx)) {
      ptrlog[i,j]<- dnorm(ntrbx[i,j],ptrmean[j],ptrsd[j],log=TRUE)
      ptrlog[i,j]<-ptrlog[i,j] + log(nrow(ptregs)/(nrow(ptregs)+nrow(ntregs)))
      
      ntrlog[i,j]<- dnorm(ntrbx[i,j],ntrmean[j],ntrsd[j],log=TRUE)
      ntrlog[i,j]<- ntrlog[i,j] + log(nrow(ntregs)/(nrow(ntregs)+nrow(ptregs)))
      
    }
  }
  
  for(j in 1:length(ntebx)) {
    for(i in 1:nrow(ntebx)) {
      
      ptelog[i,j]<- dnorm(ntebx[i,j],ptrmean[j],ptrsd[j],log=TRUE)
      ptelog[i,j]<-ptelog[i,j] + log(nrow(ptregs)/(nrow(ptregs)+nrow(ntregs)))
      
      ntelog[i,j]<- dnorm(ntebx[i,j],ntrmean[j],ntrsd[j],log=TRUE)
      ntelog[i,j]<- ntelog[i,j] + log(nrow(ntregs)/(nrow(ntregs)+nrow(ptregs)))
      
    }
  }
  
  lvwtr<-ptrlog>ntrlog
  gotrighttr<-lvwtr==ntrby
  trscore[wi]<-sum(gotrighttr,na.rm=TRUE)/(sum(gotrighttr,na.rm=TRUE)+sum(!gotrighttr,na.rm=TRUE))
  
  lvwte<-ptelog>ntelog
  gotrightte<-lvwte==nteby
  tescore[wi]<-sum(gotrightte,na.rm=TRUE)/(sum(gotrightte,na.rm=TRUE)+sum(!gotrightte,na.rm=TRUE))
}