#--------------------------------------------------------------------------------------------
# Attempt at Low Dimension representation for Part 1
#--------------------------------------------------------------------------------------------

distance_matrix2 <- matrix(0L,nrow=10,ncol=10)
save_variance_df <- data.frame()

for (label1 in 1:10) {
  
  image.matrix <- as.matrix(eval(parse(text = paste("images.rgb.df.",label1,sep=""))))
  
  image.mean.matrix <- matrix(data=eval(parse(text = paste("images.rgb.df.",label1,".mean",sep=""))),nrow=6000,ncol=3072,byrow=TRUE)
  
  image.matrix <- image.matrix - image.mean.matrix
  
  assign(paste("images.rgb.reconst_1.df.",label1,sep=""),matrix(nrow=0,ncol=3072))
    
  sumofpc <- 0
    
  for (pc in 1:20) {
      
      rprcomp <- eval(parse(text = paste("prcomp.label.",label1,sep="")))$rotation[,pc]
      tprcomp <- t(rprcomp)
      sumofpc = sumofpc + ((image.matrix %*% as.vector(tprcomp)) %*% rprcomp)
  }
    
    assign(paste("images.rgb.reconst_1.df.",label1,sep=""),(image.mean.matrix + sumofpc))
    E_value = sum(rowSums((eval(parse(text = paste("images.rgb.df.",label1,sep="")))-eval(parse(text = paste("images.rgb.reconst_1.df.",label1,sep=""))))^2))/6000
 
    save_variance_df <- rbind.data.frame(save_variance_df, c(E_value),stringsAsFactors = FALSE)
    eval(parse(text = paste("rm(images.rgb.reconst_1.df.",label1,")",sep="")))
}

rownames(save_variance_df) <- c("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck")
