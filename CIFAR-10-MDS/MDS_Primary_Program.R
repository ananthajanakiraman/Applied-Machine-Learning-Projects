#-------------------------------------------------------------------------------------------------------------------------------
# Prepare for reading data from binary image files.
#-------------------------------------------------------------------------------------------------------------------------------

labels <- read.table("batches.meta.txt")
images.rgb <- list()
images.lab <- list()
num.images = 10000 # Set to 10000 to retrieve all images per file to memory
count <- 0

#------------------------------------------------------------------------------------------------------
# Cycle through all 6 binary files
#------------------------------------------------------------------------------------------------------

for (f in 1:6) {
  to.read <- file(paste("data_batch_", f, ".bin", sep=""), "rb")
  for(i in 1:num.images) {
    l <- readBin(to.read, integer(), size=1, n=1, endian="big")
    r <- as.integer(readBin(to.read, raw(), size=1, n=1024, endian="big"))
    g <- as.integer(readBin(to.read, raw(), size=1, n=1024, endian="big"))
    b <- as.integer(readBin(to.read, raw(), size=1, n=1024, endian="big"))
    index <- num.images * (f-1) + i
    images.rgb[[index]] = data.frame(r, g, b,stringsAsFactors = FALSE)
    images.lab[[index]] = l+1
  }
  close(to.read)
  remove(l,r,g,b,f,i,index, to.read)
}

#-------------------------------------------------------------------------------------------------------------------------------
# Matrix structures to store the image data of respective categories. I tried using dataframe, believe me they were REALLY SLOW!
# Created these unflattened matrices thinking they might be useful but never used them
#-------------------------------------------------------------------------------------------------------------------------------

#images.rgb.1 <- matrix(0L,ncol=3)
#images.rgb.2 <- matrix(0L,ncol=3)
#images.rgb.3 <- matrix(0L,ncol=3)
#images.rgb.4 <- matrix(0L,ncol=3)
#images.rgb.5 <- matrix(0L,ncol=3)
#images.rgb.6 <- matrix(0L,ncol=3)
#images.rgb.7 <- matrix(0L,ncol=3)
#images.rgb.8 <- matrix(0L,ncol=3)
#images.rgb.9 <- matrix(0L,ncol=3)
#images.rgb.10 <- matrix(0L,ncol=3)

#for (j in 1:length(images.lab)) {

#  cat("Processing : ",j,"\n")
#  k <- images.lab[[j]]
#  assign(paste("images.rgb.",k,sep=""),rbind(eval(parse(text = paste("images.rgb.",k,sep=""))),as.matrix(images.rgb[[j]])))

  # Usage of dataframes not ideal in this case
  #assign(paste("images.rgb.",k,sep=""),rbind.data.frame(eval(parse(text = paste("images.rgb.",k,sep=""))),images.rgb[[j]],stringsAsFactors = FALSE))
#}

#-------------------------------------------------------------------------------------------------------------------------------
# Matrix structures to store the image data of respective categories. I tried using dataframe, believe me they were REALLY SLOW!
# Created these image data flattened matrices and used these all along.
#-------------------------------------------------------------------------------------------------------------------------------
images.rgb.df.1 <- matrix(0L,ncol=3072)
images.rgb.df.2 <- matrix(0L,ncol=3072)
images.rgb.df.3 <- matrix(0L,ncol=3072)
images.rgb.df.4 <- matrix(0L,ncol=3072)
images.rgb.df.5 <- matrix(0L,ncol=3072)
images.rgb.df.6 <- matrix(0L,ncol=3072)
images.rgb.df.7 <- matrix(0L,ncol=3072)
images.rgb.df.8 <- matrix(0L,ncol=3072)
images.rgb.df.9 <- matrix(0L,ncol=3072)
images.rgb.df.10 <- matrix(0L,ncol=3072)

for (j in 1:length(images.lab)) {

  cat("Processing : ",j,"\n")
  
  k <- images.lab[[j]]
  assign(paste("images.rgb.df.",k,sep=""),rbind(eval(parse(text = paste("images.rgb.df.",k,sep=""))),matrix(as.matrix(images.rgb[[j]]),ncol=3072,byrow=TRUE)))

  # Dataframes not the best choice in this case and so switched to using matrices as seen above
  #img.cbind <- cbind(t(img1$r),t(img1$g),t(img1$b))
  #img_df <- rbind.data.frame(img.cbind,stringsAsFactors = FALSE)
  #assign(paste("images.rgb.df.",k,sep=""),rbind.data.frame(eval(parse(text = paste("images.rgb.df.",k,sep=""))),img_df,stringsAsFactors = FALSE))
  
}

# Low Performance mean of image categories calculation - Wishful thinking
# source("HW3_mean_calc.R")

#-------------------------------------------------------------------------------------------------------------------------------
#Stunningly fast ColMeans for calculating means of image categories
#-------------------------------------------------------------------------------------------------------------------------------
  
images.rgb.df.1.mean <- matrix(colMeans(images.rgb.df.1),ncol=3072)
images.rgb.df.2.mean <- matrix(colMeans(images.rgb.df.2),ncol=3072)
images.rgb.df.3.mean <- matrix(colMeans(images.rgb.df.3),ncol=3072)
images.rgb.df.4.mean <- matrix(colMeans(images.rgb.df.4),ncol=3072)
images.rgb.df.5.mean <- matrix(colMeans(images.rgb.df.5),ncol=3072)
images.rgb.df.6.mean <- matrix(colMeans(images.rgb.df.6),ncol=3072)
images.rgb.df.7.mean <- matrix(colMeans(images.rgb.df.7),ncol=3072)
images.rgb.df.8.mean <- matrix(colMeans(images.rgb.df.8),ncol=3072)
images.rgb.df.9.mean <- matrix(colMeans(images.rgb.df.9),ncol=3072)
images.rgb.df.10.mean <- matrix(colMeans(images.rgb.df.10),ncol=3072)

#------------------------------------------------------------------------------------------------------------------------------------------------
# Create covariance matrices for PCA. Notice usage of scale function to ONLY center image
# The next commented section shows trying to manually center before creating covariance matrices and performing PCA which in effect was the same
#------------------------------------------------------------------------------------------------------------------------------------------------

images.rgb.1.covmat <- cov(centered.1 <- scale(images.rgb.df.1,center=TRUE,scale=FALSE))
images.rgb.2.covmat <- cov(centered.2 <- scale(images.rgb.df.2,center=TRUE,scale=FALSE))
images.rgb.3.covmat <- cov(centered.3 <- scale(images.rgb.df.3,center=TRUE,scale=FALSE))
images.rgb.4.covmat <- cov(centered.4 <- scale(images.rgb.df.4,center=TRUE,scale=FALSE))
images.rgb.5.covmat <- cov(centered.5 <- scale(images.rgb.df.5,center=TRUE,scale=FALSE))
images.rgb.6.covmat <- cov(centered.6 <- scale(images.rgb.df.6,center=TRUE,scale=FALSE))
images.rgb.7.covmat <- cov(centered.7 <- scale(images.rgb.df.7,center=TRUE,scale=FALSE))
images.rgb.8.covmat <- cov(centered.8 <- scale(images.rgb.df.8,center=TRUE,scale=FALSE))
images.rgb.9.covmat <- cov(centered.9 <- scale(images.rgb.df.9,center=TRUE,scale=FALSE))
images.rgb.10.covmat <- cov(centered.10 <- scale(images.rgb.df.10,center=TRUE,scale=FALSE))

#-------------------------------------------------------------------------------------------------------------------------------
#Slow performance manual centering of images and then doing covariance & PCA - Same effect and another case of Wishful Thinking!
#-------------------------------------------------------------------------------------------------------------------------------

#for (j in 1:length(images.lab))
#{
#  img_df <- data.frame()
  
#  cat("Processing : ",j,"\n")
#  k <- images.lab[[j]]
#  img_actual <- images.rgb[[j]]
#  if (k==1) { img1 <- (img_actual - images.rgb.1.mean) }
#  if (k==2) { img1 <- (img_actual - images.rgb.2.mean) }
#  if (k==3) { img1 <- (img_actual - images.rgb.3.mean) }
#  if (k==4) { img1 <- (img_actual - images.rgb.4.mean) }
#  if (k==5) { img1 <- (img_actual - images.rgb.5.mean) }
#  if (k==6) { img1 <- (img_actual - images.rgb.6.mean) }
#  if (k==7) { img1 <- (img_actual - images.rgb.7.mean) }
#  if (k==8) { img1 <- (img_actual - images.rgb.8.mean) }
#  if (k==9) { img1 <- (img_actual - images.rgb.9.mean) }
#  if (k==10) { img1 <- (img_actual - images.rgb.10.mean) }
#  img.cbind <- cbind(t(img1$r),t(img1$g),t(img1$b))
#  img_df <- rbind.data.frame(img.cbind,stringsAsFactors = FALSE)
#  assign(paste("images.rgb.df.",k,sep=""),rbind.data.frame(eval(parse(text = paste("images.rgb.df.",k,sep=""))),img_df,stringsAsFactors = FALSE))
#}

#-------------------------------------------------------------------------------------------------------------------------------
# Perform PCA
#-------------------------------------------------------------------------------------------------------------------------------

prcomp.label.1 <- prcomp(images.rgb.1.covmat,center = TRUE)
prcomp.label.2 <- prcomp(images.rgb.2.covmat,center = TRUE)
prcomp.label.3 <- prcomp(images.rgb.3.covmat,center = TRUE)
prcomp.label.4 <- prcomp(images.rgb.4.covmat,center = TRUE)
prcomp.label.5 <- prcomp(images.rgb.5.covmat,center = TRUE)
prcomp.label.6 <- prcomp(images.rgb.6.covmat,center = TRUE)
prcomp.label.7 <- prcomp(images.rgb.7.covmat,center = TRUE)
prcomp.label.8 <- prcomp(images.rgb.8.covmat,center = TRUE)
prcomp.label.9 <- prcomp(images.rgb.9.covmat,center = TRUE)
prcomp.label.10 <- prcomp(images.rgb.10.covmat,center = TRUE)

#-------------------------------------------------------------------------------------------------------------------------------
# Calculate variance - Eigen Values
#-------------------------------------------------------------------------------------------------------------------------------

label.1.variance <- prcomp.label.1$sdev^2
label.2.variance <- prcomp.label.2$sdev^2
label.3.variance <- prcomp.label.3$sdev^2
label.4.variance <- prcomp.label.4$sdev^2
label.5.variance <- prcomp.label.5$sdev^2
label.6.variance <- prcomp.label.6$sdev^2
label.7.variance <- prcomp.label.7$sdev^2
label.8.variance <- prcomp.label.8$sdev^2
label.9.variance <- prcomp.label.9$sdev^2
label.10.variance <- prcomp.label.10$sdev^2

#-------------------------------------------------------------------------------------------------------------------------------
# Plot variance by image categories
#-------------------------------------------------------------------------------------------------------------------------------

plot_df <- data.frame("airplane",round(sum(label.1.variance[21:3072]),0),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("automobile",round(sum(label.2.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("bird",round(sum(label.3.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("cat",round(sum(label.4.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("deer",round(sum(label.5.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("dog",round(sum(label.6.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("frog",round(sum(label.7.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("horse",round(sum(label.8.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("ship",round(sum(label.9.variance[21:3072]),0)),stringsAsFactors = FALSE)
plot_df <- rbind.data.frame(plot_df, c("truck",round(sum(label.10.variance[21:3072]),0)),stringsAsFactors = FALSE)
colnames(plot_df) <- c("label","variance")

ggplot(plot_df,aes(x=plot_df$label,y=as.numeric(plot_df$variance))) +
  geom_bar(stat="identity", fill="steelblue") +
  xlab("label") + ylab("variance")

#Low dimensional representation for part 1
#source("HW3_Part1_LowD_rep.R")

#-------------------------------------------------------------------------------------------------------------------------------
# Perform MDS (Euclidean distance measure) using Mean Images
#-------------------------------------------------------------------------------------------------------------------------------

source("HW3_MDS_Euclidean.R")

#-------------------------------------------------------------------------------------------------------------------------------
# Perform MDS (Special Similarity measure) using first 20 PCs of other categories
#-------------------------------------------------------------------------------------------------------------------------------

source("HW3_MDS_Special_Similarity.R")

#-------------------------------------------------------------------------------------------------------------------------------
# Invoke this function to view the images
#-------------------------------------------------------------------------------------------------------------------------------

drawImage <- function(index) {

  # Testing the parsing: Convert each color layer into a matrix,
  # combine into an rgb object, and display as a plot
  img <- images.rgb[[index]]
  img.r.mat <- matrix(img$r, ncol=32, byrow = TRUE)
  img.g.mat <- matrix(img$g, ncol=32, byrow = TRUE)
  img.b.mat <- matrix(img$b, ncol=32, byrow = TRUE)
  img.col.mat <- rgb(img.r.mat, img.g.mat, img.b.mat, maxColorValue = 255)
  dim(img.col.mat) <- dim(img.r.mat)

   # Plot and output label
   library(grid)
   grid.raster(img.col.mat, interpolate=TRUE)

   # clean up
   remove(img, img.r.mat, img.g.mat, img.b.mat, img.col.mat)

   labels[[1]][images.lab[[index]]]
 
}

 drawImage(sample(1:(num.images*5), size=1))

################################################################################################################## #