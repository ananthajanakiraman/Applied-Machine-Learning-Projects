#---------------------------------------------------------------------------------------
# Low Performance! Compute mean by looping through pixels
#---------------------------------------------------------------------------------------

images.rgb.1.mean <- matrix(0L,ncol=3072)
images.rgb.2.mean <- matrix(0L,ncol=3072)
images.rgb.3.mean <- matrix(0L,ncol=3072)
images.rgb.4.mean <- matrix(0L,ncol=3072)
images.rgb.5.mean <- matrix(0L,ncol=3072)
images.rgb.6.mean <- matrix(0L,ncol=3072)
images.rgb.7.mean <- matrix(0L,ncol=3072)
images.rgb.8.mean <- matrix(0L,ncol=3072)
images.rgb.9.mean <- matrix(0L,ncol=3072)
images.rgb.10.mean <- matrix(0L,ncol=3072)

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.1),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.1[l,1]
    g_sum <- g_sum + images.rgb.1[l,2]
    b_sum <- b_sum + images.rgb.1[l,3]
  }
  
  images.rgb.1.mean <- rbind(images.rgb.1.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}


for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.2),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.2[l,1]
    g_sum <- g_sum + images.rgb.2[l,2]
    b_sum <- b_sum + images.rgb.2[l,3]
  }
  
  images.rgb.2.mean <- rbind(images.rgb.2.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.3),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.3[l,1]
    g_sum <- g_sum + images.rgb.3[l,2]
    b_sum <- b_sum + images.rgb.3[l,3]
  }
  
  images.rgb.3.mean <- rbind(images.rgb.3.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.4),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.4[l,1]
    g_sum <- g_sum + images.rgb.4[l,2]
    b_sum <- b_sum + images.rgb.4[l,3]
  }
  
  images.rgb.4.mean <- rbind(images.rgb.4.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.5),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.5[l,1]
    g_sum <- g_sum + images.rgb.5[l,2]
    b_sum <- b_sum + images.rgb.5[l,3]
  }
  
  images.rgb.5.mean <- rbind(images.rgb.5.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.6),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.6[l,1]
    g_sum <- g_sum + images.rgb.6[l,2]
    b_sum <- b_sum + images.rgb.6[l,3]
  }
  
  images.rgb.6.mean <- rbind(images.rgb.6.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.7),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.7[l,1]
    g_sum <- g_sum + images.rgb.7[l,2]
    b_sum <- b_sum + images.rgb.7[l,3]
  }
  
  images.rgb.7.mean <- rbind(images.rgb.7.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.8),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.8[l,1]
    g_sum <- g_sum + images.rgb.8[l,2]
    b_sum <- b_sum + images.rgb.8[l,3]
  }
  
  images.rgb.8.mean <- rbind(images.rgb.8.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.9),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.9[l,1]
    g_sum <- g_sum + images.rgb.9[l,2]
    b_sum <- b_sum + images.rgb.9[l,3]
  }
  
  images.rgb.9.mean <- rbind(images.rgb.9.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}

for(i in 1:1024) {
  
  r_sum <- 0
  g_sum <- 0
  b_sum <- 0
  
  for(l in seq(i,nrow(images.rgb.10),1024)) {
    cat(l," of pixel ",i,"\n")
    r_sum <- r_sum + images.rgb.10[l,1]
    g_sum <- g_sum + images.rgb.10[l,2]
    b_sum <- b_sum + images.rgb.10[l,3]
  }
  
  images.rgb.10.mean <- rbind(images.rgb.10.mean,c(r_sum/6000,g_sum/6000,b_sum/6000))
  
}