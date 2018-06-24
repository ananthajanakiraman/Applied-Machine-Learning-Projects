#Data1.txt
#—————
#          Country  Agr Min  Man  PS  Con   SI  Fin  SPS  TC
#1         Belgium  3.3 0.9 27.6 0.9  8.2 19.1  6.2 26.6 7.2
#2         Denmark  9.2 0.1 21.8 0.6  8.3 14.6  6.5 32.2 7.1
#3          France 10.8 0.8 27.5 0.9  8.9 16.8  6.0 22.6 5.7
#4      W. Germany  6.7 1.3 35.8 0.9  7.3 14.4  5.0 22.3 6.1
#5         Ireland 23.2 1.0 20.7 1.3  7.5 16.8  2.8 20.8 6.1
#6           Italy 15.9 0.6 27.6 0.5 10.0 18.1  1.6 20.1 5.7
#7      Luxembourg  7.7 3.1 30.8 0.8  9.2 18.5  4.6 19.2 6.2
#8     Netherlands  6.3 0.1 22.5 1.0  9.9 18.0  6.8 28.5 6.8
#9  United Kingdom  2.7 1.4 30.2 1.4  6.9 16.9  5.7 28.3 6.4
#10        Austria 12.7 1.1 30.2 1.4  9.0 16.8  4.9 16.8 7.0
#11        Finland 13.0 0.4 25.9 1.3  7.4 14.7  5.5 24.3 7.6
#12         Greece 41.4 0.6 17.6 0.6  8.1 11.5  2.4 11.0 6.7
#13         Norway  9.0 0.5 22.4 0.8  8.6 16.9  4.7 27.6 9.4
#14       Portugal 27.8 0.3 24.5 0.6  8.4 13.3  2.7 16.7 5.7
#15          Spain 22.9 0.8 28.5 0.7 11.5  9.7  8.5 11.8 5.5
#16         Sweden  6.1 0.4 25.9 0.8  7.2 14.4  6.0 32.4 6.8
#17    Switzerland  7.7 0.2 37.8 0.8  9.5 17.5  5.3 15.4 5.7
#18         Turkey 66.8 0.7  7.9 0.1  2.8  5.2  1.1 11.9 3.2
#19       Bulgaria 23.6 1.9 32.3 0.6  7.9  8.0  0.7 18.2 6.7
#20 Czechoslovakia 16.5 2.9 35.5 1.2  8.7  9.2  0.9 17.9 7.0
#21     E. Germany  4.2 2.9 41.2 1.3  7.6 11.2  1.2 22.1 8.4
#22        Hungary 21.7 3.1 29.6 1.9  8.2  9.4  0.9 17.2 8.0
#23         Poland 31.1 2.5 25.7 0.9  8.4  7.5  0.9 16.1 6.9
#24        Rumania 34.7 2.1 30.1 0.6  8.7  5.9  1.3 11.7 5.0
#25           USSR 23.7 1.4 25.8 0.6  9.2  6.1  0.5 23.6 9.3
#26     Yugoslavia 48.7 1.5 16.8 1.1  4.9  6.4 11.3  5.3 4.0

library("cluster", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")
library(ape)

employment_df <- read.csv("data1.txt",sep="\t")

dist_mat <- dist(as.matrix(employment_df[,2:10],method = "euclidean",upper = TRUE,diag = TRUE)
hclustobj_average <- hclust(dist_mat,method="average")
plot(as.phylo(hclustobj_average), type='fan')
hclustobj_complete <- hclust(dist_mat,method="complete")
plot(as.phylo(hclustobj_complete), type='fan')
hclustobj_single <- hclust(dist_mat,method="single")
plot(as.phylo(hclustobj_single), type='fan')

employment_df1 <- employment_df[,2:10]
rownames(employment_df1) <- employment_df[,"Country"]
k.max <- 10
wss <- sapply(1:k.max,function(k){kmeans(employment_df1, k, nstart=50,iter.max = 15 )$tot.withinss})
plot(1:k.max, wss, type="b", pch = 19, frame = FALSE, xlab="Number of clusters K", ylab="Total within-clusters sum of squares")
km <- kmeans(employment_df1,3)
clusplot(employment_df1,km$cluster,color = TRUE,shade = TRUE,labels=2,lines=0,main = "Kmeans Cluster Plot")

employment_df2 <- data.frame(scale(employment_df1))
plot(sapply(employment_df2, var))
pc <- princomp(employment_df2)
plot(pc,main = "Princomp Variance")

pc <- prcomp(employment_df2)
comp <- data.frame(pc$x[,1:2])
k <- kmeans(comp, 3, nstart=25, iter.max=1000)
clusplot(comp,k$cluster,color = TRUE,shade = TRUE,labels=2,lines=0,main = "KMeans Clustering Plot")
