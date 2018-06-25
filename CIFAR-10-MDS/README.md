**Dataset**

CIFAR-10 is a dataset of 32x32 images in 10 categories, collected by Alex Krizhevsky, Vinod Nair, and Geoffrey Hinton. It is often used to evaluate machine learning algorithms. It can be downloaded from https:// www.cs.toronto.edu/~kriz/cifar.html.

The dataset consists of 60000 32x32 colour images in 10 classes, with 6000 images per class. There are 50000 training images and 10000 test images. The dataset is divided into five training batches and one test batch, each with 10000 images. The test batch contains exactly 1000 randomly-selected images from each class. The training batches contain the remaining images in random order, but some training batches may contain more images from one class than another. Between them, the training batches contain exactly 5000 images from each class.

The label classes in the dataset are:

+ airplane 
+ automobile 
+ bird 
+ cat 
+ deer 
+ dog 
+ frog 
+ horse 
+ ship 
+ truck

The classes are completely mutually exclusive. There is no overlap between automobiles and trucks. "Automobile" includes sedans, SUVs, things of that sort. "Truck" includes only big trucks. Neither includes pickup trucks.

**Image Similarity and Principal Coordinate Analysis**

I cycled through the binary image files and imported the dataset into R dataframe using the readBin function. The dataset contained three columns corresponding to the r,g and b values of the individual images. I used the grid.raster function in R to reconstruct a few sample images just to confirm that the import was successful.

For each category, computed the mean image and the first 20 principal components. Plotted the error resulting from representing the images of each category using the first 20 principal components against the category. Below is the plot -

<img src="Plot_Part1.png">


