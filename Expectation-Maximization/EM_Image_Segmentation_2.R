# PROBLEM 2 - PART 2
#1. Data Pre-process
library(grid)
library(jpeg)

input_image <- readJPEG("smallsunset.jpg")
r <- matrix(as.vector(t(input_image[,,1]))*255,ncol = 1)
g <- matrix(as.vector(t(input_image[,,2]))*255,ncol = 1)
b <- matrix(as.vector(t(input_image[,,3]))*255,ncol = 1)
xi_image <- cbind(r,g,b)
colnames(xi_image) <- c("r","g","b")

#Check original image
r1 <- matrix(data=r,ncol=600,byrow = TRUE)
g1 <- matrix(data=g,ncol=600,byrow = TRUE)
b1 <- matrix(data=b,ncol=600,byrow = TRUE)
col <- rgb(r1,g1,b1,maxColorValue = 255)
dim(col) <- dim(r1)
grid.raster(col,interpolate = FALSE)


#2. Perform initial cluster and compute initial pi and pj
#no of segments
set.seed(12345) # <-- Adjust the seed appropriately
k <- 20         # <-- Change number of segments only here
initial_cluster <- kmeans(xi_image,k,iter.max = 30)
xi_image <- cbind(xi_image,"cluster"=initial_cluster$cluster)
initial_pi <- as.matrix(table(initial_cluster$cluster))
initial_pi <- cbind(initial_pi,initial_pi[,1]/198000)
initial_mu <- initial_cluster$centers

mu_matrix <- initial_mu
pi_matrix <- as.matrix(initial_pi[,2])
work_matrix <- matrix(data=1,nrow = 198000,ncol=k,byrow = TRUE)
log_w_ij <- matrix(data=0,nrow = 198000,ncol=k,byrow = TRUE)
hold_mat <- matrix(data=0,nrow = 198000,ncol=1,byrow = TRUE)
iteration=0

#3. E-step
repeat {
  iteration = iteration+1
  print(iteration)
  log_w_ij <- matrix(data=0,nrow = 198000,ncol=k,byrow = TRUE)
  
  #LOW PERFORMANCE CODE!! - 4.5 Minutes for loop completion in each iteration  
  #for(i in 1:307200) {
  #  for (j in 1:k) {
  #    work_matrix[i,j] <- (-(t(matrix((xi_image[i,c(1:3)] - mu_matrix[j,]))) %*% matrix((xi_image[i,c(1:3)] - mu_matrix[j,])))/2) + log(pi_matrix[j,])
  #  }
  #}

  #LOW PERFORMANCE CODE!! - 2.5Mins for loop completion in each iteration
  #for(j in 1:k) {
  #  rep_matrix <- matrix(data=mu_matrix[j,],nrow=198000,ncol=3,byrow = TRUE)
  #  temp_matrix <- xi_image[,c(1:3)] - rep_matrix
  #  for(i in 1:198000) { hold_mat[i,] <- -(tcrossprod(temp_matrix[i,],t(temp_matrix[i,])))/2+log(pi_matrix[j,]) }
  #  if (j==1) { work_matrix <- cbind(hold_mat)} else { work_matrix <- cbind(work_matrix,hold_mat)}
  #}
  
  for(j in 1:k) {
    rep_matrix <- matrix(data=mu_matrix[j,],nrow=198000,ncol=3,byrow = TRUE)
    temp_matrix <- xi_image[,c(1:3)] - rep_matrix
    hold_mat[,1] <- rowSums(cbind(temp_matrix[,1]^2,temp_matrix[,2]^2,temp_matrix[,3]^2))
    hold_mat[,1] <- -(hold_mat[,1]/2)+log(pi_matrix[j,])
    if (j==1) { work_matrix <- cbind(as.matrix(hold_mat))} else { work_matrix <- cbind(work_matrix,as.matrix(hold_mat))}
  }
  
  #compute w_ij
  for (i in 1:198000) {
    #   print(i)
    log_w_ij[i,] <- work_matrix[i,] - matrix(data=logSumExp(work_matrix[i,]),nrow=1,ncol=k, byrow=TRUE)
  }
  
  w_ij <- exp(log_w_ij)
  for(i in 1:nrow(w_ij)){
    temp_w_ij <- w_ij[i,]
    temp_w_ij[temp_w_ij < 1e-5] <- 1e-5
    w_ij[i,] <- temp_w_ij
  }
  
  Q_final <- work_matrix * w_ij
 
  if (iteration > 1) {
    check_diff <- as.matrix(abs(w_ij - w_ij_prev))
    if(all(check_diff < 1e-6))
    {
      break
    } else {
      w_ij_prev <- w_ij
    }
    
  } else {
    w_ij_prev <- w_ij
  }
  if(iteration > 1) { cat("Difference count: ",length(check_diff[check_diff>1e-6]),"\n") }
  
  #4. M-step
  pi_matrix_maximized <- as.matrix(colSums(w_ij))
  pi_matrix_maximized <- pi_matrix_maximized/198000
  
  mu_maximized <- matrix(data=0,nrow = k,ncol=3)
  
  for(j in 1:k) {
    mu_numerator <- cbind(w_ij[,j] * xi_image[,"r"])
    mu_numerator <- cbind(mu_numerator,w_ij[,j] * xi_image[,"g"])
    mu_numerator <- cbind(mu_numerator,w_ij[,j] * xi_image[,"b"])
    mu_denominator <- sum(w_ij[,j])
    mu_maximized[j,] <- colSums(mu_numerator)/mu_denominator
  }
  
  mu_matrix <- mu_maximized
  pi_matrix <- pi_matrix_maximized
  
}

#5. Image Reconstruction using Mean values
xi_image_1 <- xi_image[,c(1:3)]
for (i in 1:k) {
  print(i)
  xi_image_1[xi_image[,4]==i,1] <- mu_matrix[i,1]
  xi_image_1[xi_image[,4]==i,2] <- mu_matrix[i,2]
  xi_image_1[xi_image[,4]==i,3] <- mu_matrix[i,3]
}

r1 <- matrix(data=xi_image_1[,1],ncol=600,byrow = TRUE)
g1 <- matrix(data=xi_image_1[,2],ncol=600,byrow = TRUE)
b1 <- matrix(data=xi_image_1[,3],ncol=600,byrow = TRUE)
col <- rgb(r1,g1,b1,maxColorValue = 255)
dim(col) <- dim(r1)
grid.raster(col,interpolate = FALSE)

#----------------------------------------------------------------------------------------------------------------
