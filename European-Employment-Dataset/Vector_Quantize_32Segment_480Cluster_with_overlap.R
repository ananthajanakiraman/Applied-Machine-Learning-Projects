data.cat <- data.frame()
final_df <- data.frame()
clusterno <- vector()

create_big_data_from_csv_dir <- function(hmp, directory, ids) {
  
  files <<- list.files(directory, full.names=T)[ids]
  data.list <<- lapply(files, read.csv,sep=" ")
  
  for (i in 1:length(data.list)) {
    df1 <<- as.data.frame(data.list[i],stringsAsFactors = FALSE)
    df2 <<- split(df1,(as.numeric(rownames(df1))-1) %/% 32)
    
    if (length(df2[[length(df2)]][[1]]) < 32) {
#      df2 <<- df2[1:(length(df2)-1)]
       df_overlap <<- df2[[length(df2)-1]][(length(df2[[length(df2)]][[1]])+1):32,]
       df2[[length(df2)]] <<- rbind.data.frame(df_overlap,df2[[length(df2)]],stringsAsFactors = FALSE)
    }
    
    for (j in 1:length(df2)) {
      colnames(df2[[j]]) <<- c("x","y","z")
      final_df <<- rbind.data.frame(final_df,cbind.data.frame(t(df2[[j]]$x),t(df2[[j]]$y),t(df2[[j]]$z),hmp,i))
    }
    
  }
  
}

#-----------------------------------------------------------------------------------------------------------------
# 1. Create Dictionary and Training features
#-----------------------------------------------------------------------------------------------------------------  
create_big_data_from_csv_dir("brush_teeth","/Users/anantha/rwork3/Actual/Brush_teeth")
create_big_data_from_csv_dir("climb_stairs","/Users/anantha/rwork3/Actual/Climb_stairs")
create_big_data_from_csv_dir("comb_hair","/Users/anantha/rwork3/Actual/Comb_hair")
create_big_data_from_csv_dir("descend_stairs","/Users/anantha/rwork3/Actual/Descend_stairs")
create_big_data_from_csv_dir("drink_glass","/Users/anantha/rwork3/Actual/Drink_glass")
create_big_data_from_csv_dir("eat_meat","/Users/anantha/rwork3/Actual/Eat_meat")
create_big_data_from_csv_dir("eat_soup","/Users/anantha/rwork3/Actual/Eat_soup")
create_big_data_from_csv_dir("getup_bed","/Users/anantha/rwork3/Actual/Getup_bed")
create_big_data_from_csv_dir("liedown_bed","/Users/anantha/rwork3/Actual/Liedown_bed")
create_big_data_from_csv_dir("pour_water","/Users/anantha/rwork3/Actual/Pour_water")
create_big_data_from_csv_dir("sitdown_chair","/Users/anantha/rwork3/Actual/Sitdown_chair")
create_big_data_from_csv_dir("standup_chair","/Users/anantha/rwork3/Actual/Standup_chair")
create_big_data_from_csv_dir("use_telephone","/Users/anantha/rwork3/Actual/Use_telephone")
create_big_data_from_csv_dir("walk","/Users/anantha/rwork3/Actual/Walk")

colnames(final_df) <- c(1:96,"hmp","signal")

dictionary_df <- final_df
training_df <- final_df
training_df <- cbind(training_df,clusterno=0)
k <- 480
km <- kmeans(final_df[,1:96],k)

center_matrix <- km$centers

for(i in 1:nrow(training_df)) {
  
  center_matrix_with_train_vect <- rbind(center_matrix,vect=training_df[i,1:96])
  dist_mat <- as.matrix(dist(center_matrix_with_train_vect,method = "euclidean",diag = TRUE,upper = TRUE))
  
  closest_cluster <- as.numeric(which.min(dist_mat["vect",1:length(km$size)]))
  training_df[i,"clusterno"] <- closest_cluster
}

training_df <- cbind.data.frame(training_df,signal_label=paste(training_df[,"hmp"],"_",training_df[,"signal"],sep=""))

#-----------------------------------------------------------------------------------------------------------------
# 2. Plot Histogram
#-----------------------------------------------------------------------------------------------------------------  
ggplot(data = training_df, mapping = aes(x = clusterno)) + 
  geom_histogram(stat = "count") + facet_wrap(~signal_label, scales = 'free_x')

#HMP Breakdown within the training dataframe
#tvm_df <- training_df[1:663,c("signal_label","clusterno")] #brush_teeth
#tvm_df <- training_df[664:1657,c("signal_label","clusterno")] #climb_stairs
#tvm_df <- training_df[1658:2245,c("signal_label","clusterno")] #comb_hair
#tvm_df <- training_df[2246:2640,c("signal_label","clusterno")] #descend_stairs
#tvm_df <- training_df[2641:3612,c("signal_label","clusterno")] #drink_glass
#tvm_df <- training_df[3613:4295,c("signal_label","clusterno")] #eat_meat
#tvm_df <- training_df[4296:4433,c("signal_label","clusterno")] #eat_soup
#tvm_df <- training_df[4434:5543,c("signal_label","clusterno")] #getup_bed
#tvm_df <- training_df[5544:5815,c("signal_label","clusterno")] #liedown_bed
#tvm_df <- training_df[5816:6834,c("signal_label","clusterno")] #pour_water
#tvm_df <- training_df[6835:7366,c("signal_label","clusterno")] #sitdown_chair
#tvm_df <- training_df[7367:7942,c("signal_label","clusterno")] #standup_chair
#tvm_df <- training_df[7943:8319,c("signal_label","clusterno")] #use_telephone
#tvm_df <- training_df[8320:9316,c("signal_label","clusterno")] #walk - 1
#tvm_df <- training_df[9317:10546,c("signal_label","clusterno")] #walk - 2

#-----------------------------------------------------------------------------------------------------------------
# Features Type-1
#-----------------------------------------------------------------------------------------------------------------
training_vector_table <- table(training_df[,c("signal_label","clusterno")])
training_vector <- as.data.frame.matrix(training_vector_table,stringsAsFactors = FALSE)
training_vector <- cbind.data.frame(training_vector,label=rownames(training_vector),stringsAsFactors=FALSE)
for(i in 1:nrow(training_vector)) {
  training_vector[i,"label"] <- substr(training_vector[i,"label"],1,regexpr("\\_[^\\_]*$", training_vector[i,"label"])[1]-1)
}


#-----------------------------------------------------------------------------------------------------------------
# 3. Vector quantize Test data and generate features 
#-----------------------------------------------------------------------------------------------------------------  
final_df <- data.frame()

create_big_data_from_csv_dir("brush_teeth","/Users/anantha/rwork3/Test/Brush_teeth")
create_big_data_from_csv_dir("climb_stairs","/Users/anantha/rwork3/Test/Climb_stairs")
create_big_data_from_csv_dir("comb_hair","/Users/anantha/rwork3/Test/Comb_hair")
create_big_data_from_csv_dir("descend_stairs","/Users/anantha/rwork3/Test/Descend_stairs")
create_big_data_from_csv_dir("drink_glass","/Users/anantha/rwork3/Test/Drink_glass")
create_big_data_from_csv_dir("eat_meat","/Users/anantha/rwork3/Test/Eat_meat")
create_big_data_from_csv_dir("eat_soup","/Users/anantha/rwork3/Test/Eat_soup")
create_big_data_from_csv_dir("getup_bed","/Users/anantha/rwork3/Test/Getup_bed")
create_big_data_from_csv_dir("liedown_bed","/Users/anantha/rwork3/Test/Liedown_bed")
create_big_data_from_csv_dir("pour_water","/Users/anantha/rwork3/Test/Pour_water")
create_big_data_from_csv_dir("sitdown_chair","/Users/anantha/rwork3/Test/Sitdown_chair")
create_big_data_from_csv_dir("standup_chair","/Users/anantha/rwork3/Test/Standup_chair")
create_big_data_from_csv_dir("use_telephone","/Users/anantha/rwork3/Test/Use_telephone")
create_big_data_from_csv_dir("walk","/Users/anantha/rwork3/Test/Walk")

colnames(final_df) <- c(1:96,"hmp","signal")

testing_df <- final_df
testing_df <- cbind(testing_df,clusterno=0)

for(i in 1:nrow(testing_df)) {
  
  center_matrix_with_test_vect <- rbind(center_matrix,vect=testing_df[i,1:96])
  dist_mat <- as.matrix(dist(center_matrix_with_test_vect,method = "euclidean",diag = TRUE,upper = TRUE))
  
  closest_cluster <- as.numeric(which.min(dist_mat["vect",1:length(km$size)]))
  testing_df[i,"clusterno"] <- closest_cluster
}

#-----------------------------------------------------------------------------------------------------------------
# Features Type-1
#-----------------------------------------------------------------------------------------------------------------
testing_df <- cbind.data.frame(testing_df,signal_label=paste(testing_df[,"hmp"],"_",testing_df[,"signal"],sep=""))
testing_vector_table <- table(testing_df[,c("signal_label","clusterno")])
testing_vector <- as.data.frame.matrix(testing_vector_table,stringsAsFactors = FALSE)
testing_vector <- cbind.data.frame(testing_vector,label=rownames(testing_vector),stringsAsFactors=FALSE)
for(i in 1:nrow(testing_vector)) {
  testing_vector[i,"label"] <- substr(testing_vector[i,"label"],1,regexpr("\\_[^\\_]*$", testing_vector[i,"label"])[1]-1)
}

#-----------------------------------------------------------------------------------------------------------------
# 4. Do Random Forest Classification on Training Data and Predict Test
#-----------------------------------------------------------------------------------------------------------------  
features <- colnames(training_vector)[!(colnames(training_vector) %in% "label")]
h2o.init(nthreads = -1, max_mem_size = '2g', ip = "127.0.0.1", port = 50001)
trainhex <- as.h2o(training_vector)
trainhex[,"label"] <- as.factor(trainhex[,"label"])
rfhex <- h2o.randomForest(x=features,y="label",ntrees = 30,max_depth = 16,training_frame=trainhex)

testhex<-as.h2o(testing_vector)
testhex[,"label"] <- as.factor(testhex[,"label"])
predictions<-as.data.frame(h2o.predict(rfhex,testhex))
mean(predictions$predict==testing_vector$label)

performance <- h2o.performance(model=rfhex,newdata=testhex)
cm <- as.data.frame(h2o.confusionMatrix(performance))
h2o.shutdown(prompt = FALSE)

