show_digit = function(arr784, col = gray(12:1 / 12), ...) {
  image(matrix(as.matrix(arr784[-785]), nrow = 28)[,28:1], col = col, ...)
}

# load image files
load_image_file = function(filename) {
  ret = list()
  f = file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  n    = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  nrow = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  ncol = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  x = readBin(f, 'integer', n = n * nrow * ncol, size = 1, signed = FALSE)
  x1 <<- x
  
  print(nrow)
  print(ncol)
  print(x)
  close(f)
  data.frame(matrix(x, ncol = nrow * ncol, byrow = TRUE))
}

# load label files
load_label_file = function(filename) {
  f = file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  n = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  y = readBin(f, 'integer', n = n, size = 1, signed = FALSE)
  close(f)
  y
}

# load images
training = load_image_file("train-images-idx3-ubyte")
test  = load_image_file("t10k-images-idx3-ubyte")

# load labels
training$y = as.factor(load_label_file("train-labels-idx1-ubyte"))
test$y  = as.factor(load_label_file("t10k-labels-idx1-ubyte"))

# view test image
show_digit(training[1, ])

#mrf_training <- training[,-785]
#mrf_training[1:20,] <- mrf_training[1:20,]/255
#mrf_training[mrf_training[1:20,]>0.5,][1:20,] <- 1
#mrf_training[mrf_training[1:20,]<0.5,][1:20,] <- -1
images_20 <- training[1:20,-785]

#for(i in 1:20) {
#  temp_matrix <- matrix(as.matrix(images_20[i,]), nrow = 28)[,28:1]
#  images_20[i,] <- matrix(data=temp_matrix,ncol=nrow(temp_matrix)*ncol(temp_matrix),byrow = TRUE) 
#}

images_20_orig <- images_20
images_20 <- images_20/255
images_20[images_20>0.5] <- 1
images_20[images_20<0.5] <- -1

row_matrix <- read.csv("row_matrix.csv",header = TRUE,stringsAsFactors = FALSE)
column_matrix <- read.csv("column_matrix.csv",header = TRUE,stringsAsFactors = FALSE)
column_matrix <- column_matrix[,2:16]
row_matrix <- row_matrix[,2:16]
column_matrix <- column_matrix+1
row_matrix <- row_matrix+1

for(i in 1:20) {
  temp_matrix <- t(matrix(as.matrix(images_20[i,]), nrow = 28))
  for(j in 1:15){
    #images_20[i,(28*(column_matrix[i,j]-1)+row_matrix[i,j])] <- images_20[i,(28*(column_matrix[i,j]-1)+row_matrix[i,j])] * -1
    temp_matrix[row_matrix[i,j],column_matrix[i,j]] <- temp_matrix[row_matrix[i,j],column_matrix[i,j]] * -1
  }
  images_20[i,] <- matrix(data=temp_matrix,ncol=nrow(temp_matrix)*ncol(temp_matrix),byrow = TRUE)
}

#compute pi_j
upd_ord_row_matrix <- read.csv("upd_ord_coords_row.csv",header = TRUE,stringsAsFactors = FALSE)
upd_ord_col_matrix <- read.csv("upd_ord_coords_col.csv",header = TRUE,stringsAsFactors = FALSE)
initial_parameters <- read.csv("InitialParametersModel.csv",header = FALSE,stringsAsFactors = FALSE)
upd_ord_col_matrix <- upd_ord_col_matrix[,2:785]
upd_ord_row_matrix <- upd_ord_row_matrix[,2:785]
theta_ij_X <- 2
theta_ij_H <- 0.8
epsilon <- 10^-10
energy_output <- matrix(data=0,nrow=20,ncol=11)

#image=1 #change to loop for images
#iteration=1 #change to loop for 10 iterations

for(image in 1:20) {

EQ_logQ <- 0
total_H_neighbor_sum <- 0
total_X_neighbor_sum <- 0 
colvalue <- 1
Q_matrix <- initial_parameters
temp_matrix <- matrix(as.matrix(images_20[image,]), nrow = 28)

########################################################################################################################################################

#Compute EQ_logQ
for (row in 1:28) {
  
  for(column in 1:28) {
    EQ_logQ <- EQ_logQ + (Q_matrix[row,column]*log(Q_matrix[row,column]+epsilon)+((1-Q_matrix[row,column])*log((1-Q_matrix[row,column])+epsilon)))
  }
  
}

#Compute EQ_log_p_of_hx
for(rowindex in 1:28) {
  
for(colindex in 1:28) {

  H_neighbor_sum_pos <- 0
  H_neighbor_sum_neg <- 0
  #pixel_row_index <- upd_ord_row_matrix[image,i]+1
  #pixel_col_index <- upd_ord_col_matrix[image,i]+1
  pixel_row_index <- rowindex
  pixel_col_index <- colindex
  
  if(length(Q_matrix[pixel_row_index-1,pixel_col_index])>0) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index-1,pixel_col_index]-1))
  }
  if(length(Q_matrix[pixel_row_index,pixel_col_index+1])>0) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index,pixel_col_index+1]-1))
  }
  if(length(Q_matrix[pixel_row_index,pixel_col_index-1])>0) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index,pixel_col_index-1]-1))
  }
  if(length(Q_matrix[pixel_row_index+1,pixel_col_index])>0 & pixel_row_index < 28) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index+1,pixel_col_index]-1))
  }
  
  total_H_neighbor_sum = total_H_neighbor_sum + H_neighbor_sum_pos 
  total_X_neighbor_sum = total_X_neighbor_sum + (theta_ij_X*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*temp_matrix[pixel_row_index,pixel_col_index])
  
   #print(total_H_neighbor_sum + total_X_neighbor_sum)
    
}
  #cat(rowindex,": ",total_H_neighbor_sum + total_X_neighbor_sum,"\n")
}

#print(EQ_logQ - (total_H_neighbor_sum+total_X_neighbor_sum))
energy_output[image,colvalue] <- (EQ_logQ - (total_H_neighbor_sum+total_X_neighbor_sum))

########################################################################################################################################################

for(iteration in 1:10) {
  
  cat("Image: ",image," Iteration: ",iteration,"\n")  
  
for(i in 1:784) {

  H_neighbor_sum_pos <- 0
  H_neighbor_sum_neg <- 0
  pixel_row_index <- upd_ord_row_matrix[image,i]+1
  pixel_col_index <- upd_ord_col_matrix[image,i]+1
  
  if(length(Q_matrix[pixel_row_index-1,pixel_col_index])>0) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index-1,pixel_col_index]-1))
    H_neighbor_sum_neg = H_neighbor_sum_neg + ((-1)*theta_ij_H*(2*Q_matrix[pixel_row_index-1,pixel_col_index]-1))
  }
  if(length(Q_matrix[pixel_row_index,pixel_col_index+1])>0) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index+1]-1))
    H_neighbor_sum_neg = H_neighbor_sum_neg + ((-1)*theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index+1]-1))
  }
  if(length(Q_matrix[pixel_row_index,pixel_col_index-1])>0) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index-1]-1))
    H_neighbor_sum_neg = H_neighbor_sum_neg + ((-1)*theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index-1]-1))
  }
  if(length(Q_matrix[pixel_row_index+1,pixel_col_index])>0 & pixel_row_index < 28) { 
    H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index+1,pixel_col_index]-1))
    H_neighbor_sum_neg = H_neighbor_sum_neg + ((-1)*theta_ij_H*(2*Q_matrix[pixel_row_index+1,pixel_col_index]-1))
  }
  
  H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_X*temp_matrix[pixel_row_index,pixel_col_index])
  H_neighbor_sum_neg = H_neighbor_sum_neg + ((-1)*(theta_ij_X*temp_matrix[pixel_row_index,pixel_col_index]))
  pi_value = exp(H_neighbor_sum_pos)/(exp(H_neighbor_sum_pos)+exp(H_neighbor_sum_neg))

  if(is.na(pi_value)) { cat("NA values observed!!","\n")}
  Q_matrix[pixel_row_index,pixel_col_index] = pi_value
}

########################################################################################################################################################  
EQ_logQ <- 0
total_H_neighbor_sum <- 0
total_X_neighbor_sum <- 0
  
for (row in 1:28) {
    
    for(column in 1:28) {
      EQ_logQ <- EQ_logQ + (Q_matrix[row,column]*log(Q_matrix[row,column]+epsilon)+((1-Q_matrix[row,column])*log((1-Q_matrix[row,column])+epsilon)))
    }
    
}
  
for(rowindex in 1:28) {
    
  for(colindex in 1:28) {
      
      H_neighbor_sum_pos <- 0
      H_neighbor_sum_neg <- 0
      #pixel_row_index <- upd_ord_row_matrix[image,i]+1
      #pixel_col_index <- upd_ord_col_matrix[image,i]+1
      pixel_row_index <- rowindex
      pixel_col_index <- colindex
      
      if(length(Q_matrix[pixel_row_index-1,pixel_col_index])>0) { 
        H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index-1,pixel_col_index]-1))
      }
      if(length(Q_matrix[pixel_row_index,pixel_col_index+1])>0) { 
        H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index,pixel_col_index+1]-1))
      }
      if(length(Q_matrix[pixel_row_index,pixel_col_index-1])>0) { 
        H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index,pixel_col_index-1]-1))
      }
      if(length(Q_matrix[pixel_row_index+1,pixel_col_index])>0 & pixel_row_index < 28) { 
        H_neighbor_sum_pos = H_neighbor_sum_pos + (theta_ij_H*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*(2*Q_matrix[pixel_row_index+1,pixel_col_index]-1))
      }
      
      total_H_neighbor_sum = total_H_neighbor_sum + H_neighbor_sum_pos 
      total_X_neighbor_sum = total_X_neighbor_sum + (theta_ij_X*(2*Q_matrix[pixel_row_index,pixel_col_index]-1)*temp_matrix[pixel_row_index,pixel_col_index])
      
      #print(total_H_neighbor_sum + total_X_neighbor_sum)
      
    }
    #cat(rowindex,": ",total_H_neighbor_sum + total_X_neighbor_sum,"\n")
  }
  
#print(EQ_logQ - (total_H_neighbor_sum+total_X_neighbor_sum))
colvalue = colvalue+1
energy_output[image,colvalue] <- (EQ_logQ - (total_H_neighbor_sum+total_X_neighbor_sum))

########################################################################################################################################################

}

#write.table(Q_matrix,paste("Q_matrix","_",image,".csv",sep=""),row.names = FALSE,col.names = FALSE,sep=",")
assign(paste("Q_matrix_",image,sep = ""),Q_matrix)

}


