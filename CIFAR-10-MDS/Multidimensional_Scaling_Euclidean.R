library(stats)
library(igraph)
library(qgraph)

#---------------------------------------------------------------------------------------------------------------------------------------
# Merge the mean for each category into a single matrix
#---------------------------------------------------------------------------------------------------------------------------------------
img_temp_df <- matrix(0L,ncol=3072)
mean_images_merged_matrix <- matrix(0L,ncol=3072)

for (i in 1:10) {

  img_temp_df <- eval(parse(text = paste("images.rgb.df.",i,".mean",sep="")))
  mean_images_merged_matrix <- rbind(mean_images_merged_matrix,img_temp_df)
  
  # Can I use a unflattened mean image matrix and flatten it here & write into a dataframe ? - Slower than working with a matrix
  #colnames(img_temp_df) <- c("r","g","b")
  #img_temp_df1 <- cbind(t(img_temp_df$r),t(img_temp_df$g),t(img_temp_df$b))

}

#---------------------------------------------------------------------------------------------------------------------------------------
# Create a Euclidean distance matrix and plot the matrix
#---------------------------------------------------------------------------------------------------------------------------------------

rownames(mean_images_merged_matrix) <- c("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck")
mean_images_dist_matrix <- dist(mean_images_merged_matrix,method="euclidean",upper = TRUE,diag = TRUE)
fit <- cmdscale(mean_images_dist_matrix, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]
plot(x, y, pch = 19, xlim = range(x), ylim = range(y))
images.names <- c("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck")
text(x, y, pos = 4, labels = images.names)


#---------------------------------------------------------------------------------------------------------------------------------------
# Tried to visualize similarity & distance through a network graph
#---------------------------------------------------------------------------------------------------------------------------------------

dist_m <- as.matrix(mean_images_dist_matrix)
dist_mi <- 1/dist_m
qgraph(dist_mi, layout='spring', vsize=8,labels=colnames(dist_mi))
dev.off()
