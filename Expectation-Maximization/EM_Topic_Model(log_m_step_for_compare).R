# PROBLEM 1 - ALL PARTS
#1. Data Pre-process
docword_df <- read.csv("docword.csv",header = TRUE,stringsAsFactors = FALSE)
vocab_df <- read.csv("vocab.csv",header = TRUE,stringsAsFactors = FALSE)
i <- docword_df$docid
j <- docword_df$wordid
x <- docword_df$count
sparsemat <- sparseMatrix(i,j,x=x)
docmat_1 <- as.matrix(sparsemat)
colnames(docmat_1) <- c(vocab_df$word)
rownames(docmat_1) <- c(1:1500)
docmat_2 <- as.matrix(sparsemat)
colnames(docmat_2) <- c(vocab_df$wordid)
rownames(docmat_2) <- c(1:1500)
remove(w_ij_prev)
total_document_count <- 1500
j=1

#KMEANS INITIALIZATION LOGIC!!
#2. Perform initial cluster and compute initial pi and pj
#initial_cluster <- kmeans(docmat_1,30)
#initial_pi <- as.matrix(table(initial_cluster$cluster))
#initial_pi <- cbind(initial_pi,initial_pi[,1]/1500)
#doc_clus_mat <- as.matrix(initial_cluster$cluster)

#RANDOM INITIALIZATION LOGIC!!
set.seed(12345)
initial_cluster <- cbind(sample(1500),0)
for (i in seq(from=1,to=1500,by=10)) {
  print(i)
  initial_cluster[c(seq(i,i+9,by=1)),2] <- j
  if (j==30) { j=1 } else { j=j+1 }
}
cluster_table <- as.vector(initial_cluster[,2])
names(cluster_table) <- initial_cluster[,1]
initial_pi <- as.matrix(table(cluster_table))
initial_pi <- cbind(initial_pi,initial_pi[,1]/1500)
doc_clus_mat <- as.matrix(cluster_table)

for(i in 1:30) {
  temp_mat <- as.matrix(docmat_1[rownames(docmat_1) %in% names(doc_clus_mat[doc_clus_mat[,1]==i,]),])
  if(ncol(temp_mat)==1) { temp_mat <- t(temp_mat) }
  total_word_count <- rowSums(t(colSums(temp_mat))) 
  if(i==1) { 
    initial_pj_matrix <- rbind(t(colSums(temp_mat))/total_word_count) 
  } else {
    initial_pj_matrix <- rbind(initial_pj_matrix,t(colSums(temp_mat))/total_word_count)
  }
}

#2a.Assign small probabilities to 0 word counts
#initial_pj_matrix[initial_pj_matrix[1:nrow(initial_pj_matrix),]==0] <- 1e-4      # try 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10
pj_matrix <- initial_pj_matrix
pi_matrix <- initial_pi[,2]

#compute xi(t).1
unit_matrix <- matrix(data=1,nrow = 1,ncol=12419)
xit_matrix <- (docmat_1 %*% as.vector(unit_matrix))

#3. E-step
#what do we know :
#initial_pj_matrix -> matrix with topic word distribution on the vocabulary - 30 X 12419
#initial_pi -> Topic weights (1 to 30) - 30 X 1
#docmat_1 -> xi vector - 1500 X 12419

logdot <- function(a, b) {
  max_a = max(a)
  max_b = max(b)
  exp_a = a - max_a
  exp_b = b - max_b
  exp_a = exp(exp_a)
  exp_b = exp(exp_b)
  c = exp_a %*% exp_b
  c = log(c)
  c = c + max_a + max_b
  return(c)
}

iteration=0
log_pj_matrix <- log(pj_matrix)
log_pi_matrix <- log(pi_matrix)
log_pi_matrix <- matrix(data=log_pi_matrix,nrow=1500,ncol=30,byrow =TRUE)

if(any(log_pj_matrix==-Inf)) {
  log_pj_matrix[log_pj_matrix[1:nrow(log_pj_matrix),]==-Inf] <- log(1e-4) 
}

repeat {
  iteration=iteration+1
  cat("Iteration : ", iteration,"\n")
  
  if(any(log_pj_matrix==-Inf)) {
    log_pj_matrix[log_pj_matrix[1:nrow(log_pj_matrix),]==-Inf] <- log(1e-4) 
 }
  
  #if(any(pi_matrix==0)) {
  #  pi_matrix[pi_matrix[1:nrow(pi_matrix),]==0] <- 1e-4     # try 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10
  #}
  
  Q_matrix <- ((docmat_1 %*% t(log_pj_matrix)) + log_pi_matrix)
  
  for (i in 1:1500) {
    if (i==1) {
      log_w_ij <- rbind(Q_matrix[i,] - matrix(data=logSumExp(Q_matrix[i,]),nrow=1,ncol=30, byrow=TRUE))  
    } else {
      log_w_ij <- rbind(log_w_ij,(Q_matrix[i,] - matrix(data=logSumExp(Q_matrix[i,]),nrow=1,ncol=30, byrow=TRUE)))
    }
  }
  
  w_ij <- exp(log_w_ij)
  
  for(i in 1:nrow(w_ij)){
    temp_w_ij <- w_ij[i,]
    temp_w_ij[temp_w_ij < 1e-4] <- 1e-4           # try 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10
    w_ij[i,] <- temp_w_ij
  }
  
  Q_final <- Q_matrix * w_ij
 
  if (iteration > 1) {
    check_diff <- as.matrix(w_ij - w_ij_prev)
    if(all(check_diff < 1e-10))                 # try 1e-7 to 1e-15
    {
      break
    } else {
      w_ij_prev <- w_ij
    }
    
  } else {
    w_ij_prev <- w_ij
  }
  
  if(iteration > 1) { cat("Difference count: ",length(check_diff[check_diff>1e-10]),"\n") }
  
  #4. M-step

  temp_log <- matrix(data=logdot(t(log_w_ij),log(xit_matrix)),nrow=30,ncol=12419)
  log_pj_matrix <- logdot(t(log_w_ij),log(docmat_1)) - temp_log
  log_pj_matrix[log_pj_matrix[1:nrow(log_pj_matrix),]==-Inf] <- log(1e-4) 
  log_pj_matrix[log_pj_matrix[1:nrow(log_pj_matrix),] < log(1e-4)] <- log(1e-4) 
  
  log_pi_matrix_hold <- matrix(data=0,nrow=30,ncol=1)
  
  for(i in 1:30) {
     log_pi_matrix_hold[i,] <- logSumExp(log_w_ij[,i]) - log(total_document_count)
  }
  
  log_pi_matrix <- matrix(data=log_pi_matrix_hold,nrow=1500,ncol=30,byrow = TRUE)
  
}

pi_matrix <- log_pi_matrix[1,]
pi_matrix <- exp(pi_matrix)
pi_max_df <- as.data.frame(pi_matrix)
colnames(pi_max_df) <- c("Topic_Probability")
pi_max_df <- cbind.data.frame(pi_max_df,Topic=rownames(pi_max_df))
pi_max_df$Topic <- factor(pi_max_df$Topic,levels=c(1:30))
ggplot(pi_max_df,aes(Topic,Topic_Probability))  + geom_bar(stat = "identity", fill = "steelblue") + coord_cartesian(ylim=c(0.00,0.09))

for (i in 1:30) {
  if(i==1){
    final_topic_table = cbind.data.frame(names(sort(pj_matrix[i,],decreasing = TRUE))[1:20])
  } else {
    final_topic_table = cbind.data.frame(final_topic_table,names(sort(pj_matrix[i,],decreasing = TRUE))[1:20])  
  }
}

colnames(final_topic_table) <- c(1:30)
