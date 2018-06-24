#----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Below logic was used in a different method for performance comparison and commenting out - Wishful thinking!
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

#images.rgb.original.df.1 <- data.frame()
#images.rgb.original.df.2 <- data.frame()
#images.rgb.original.df.3 <- data.frame()
#images.rgb.original.df.4 <- data.frame()
#images.rgb.original.df.5 <- data.frame()
#images.rgb.original.df.6 <- data.frame()
#images.rgb.original.df.7 <- data.frame()
#images.rgb.original.df.8 <- data.frame()
#images.rgb.original.df.9 <- data.frame()
#images.rgb.original.df.10 <- data.frame()

#for (j in 1:length(images.lab)) {
#  cat("Processing : ",j,"\n")
#  df_total <- data.frame()
#  k <- images.lab[[j]]
#  assign(paste("images.rgb.original.df.",k,sep=""),rbind.data.frame(eval(parse(text = paste("images.rgb.original.df.",k,sep=""))),
#                                                                    cbind.data.frame(t(images.rgb[[j]]$r),t(images.rgb[[j]]$g),t(images.rgb[[j]]$b)),
#                                                                    stringsAsFactors = FALSE))
#}

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Optimal Performance 
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1. Compute X(i)-Mean(X) - Mean(X) is the mean of the category, X(i) is the image data for the ith category/class
# 2. The original CIFAR-10 data as downloaded from the website and grouped by label resides in images.rgb.df.* 
# 3. Replicated mean for each category to the size of the category in the matrix for mathematical convenience.
# 4. For each category, loop through all the categories and use the first 20 PCs and reconstruct the image. Refer to reconstruction FORMULA!
# 5. E(A|B)/E(B|A) - Compute the difference between the original and reconstructed images, square the difference at pixel level & average over the category
# 6. Populate the distance matrix and compute 1/2 * (E(A|B) + E(B|A))
# 7. Perform MDS using cmdscale() and plot the graph

distance_matrix <- matrix(0L,nrow=10,ncol=10)

for (label1 in 1:10) {
  
  image.matrix <- as.matrix(eval(parse(text = paste("images.rgb.df.",label1,sep=""))))
  
  image.mean.matrix <- matrix(data=eval(parse(text = paste("images.rgb.df.",label1,".mean",sep=""))),nrow=6000,ncol=3072,byrow=TRUE)
  
  image.matrix <- image.matrix - image.mean.matrix
  
  cat("Processing Label : ",label1,"\n")                          
  
  for (label2 in 1:10) {
    
    assign(paste("images.rgb.reconst.df.",label1,".",label2,sep=""),matrix(nrow=0,ncol=3072))
    
    sumofpc <- 0
      
    for (pc in 1:20) {
    
        rprcomp <- eval(parse(text = paste("prcomp.label.",label2,sep="")))$rotation[,pc]
        tprcomp <- t(rprcomp)
        sumofpc = sumofpc + ((image.matrix %*% as.vector(tprcomp)) %*% rprcomp)
      }
      
      assign(paste("images.rgb.reconst.df.",label1,".",label2,sep=""),(image.mean.matrix + sumofpc))
      
      E_value = sum(rowSums((eval(parse(text = paste("images.rgb.df.",label1,sep="")))-eval(parse(text = paste("images.rgb.reconst.df.",label1,".",label2,sep=""))))^2))/6000
      distance_matrix[label1,label2] <- distance_matrix[label1,label2] + E_value
      distance_matrix[label2,label1] <- distance_matrix[label2,label1] + E_value
      
      eval(parse(text = paste("rm(images.rgb.reconst.df.",label1,".",label2,")",sep="")))
  }

}

distance_matrix <- distance_matrix/2
rownames(distance_matrix) <- c("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck")
colnames(distance_matrix) <- c("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck")

fit <- cmdscale(distance_matrix, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]
plot(x, y, pch = 19, xlim = range(x), ylim = range(y))
images.names <- c("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck")
text(x, y, pos = 4, labels = images.names)
