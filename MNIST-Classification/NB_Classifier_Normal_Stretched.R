show_digit = function(arr784, col = gray(12:1 / 12), ...) {
  image(matrix(as.matrix(arr784[-401]), nrow = 20)[, 1:20], col = col, ...)
}
# load image files
load_image_file = function(filename) {
  ret = list()
  x <- integer()
  f = file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  n1    = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  nrow = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  ncol = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  #x = readBin(f, 'integer', n = n * nrow * ncol, size = 1, signed = FALSE)
  #x1 <<- x
  for(i in 1:n1){
    print(i)
    m = matrix(readBin(f, 'integer', n = nrow * ncol, size = 1, signed = FALSE),28,28) 
    x <- c(x,as.integer(resize(autocrop(as.cimg(m[,28:1])),20,20)))
  }
  close(f)
  data.frame(matrix(x, ncol = 400, byrow = TRUE))
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
training3 = load_image_file("train-images-idx3-ubyte")
test3  = load_image_file("t10k-images-idx3-ubyte")

# load labels
training3$y = as.factor(load_label_file("train-labels-idx1-ubyte"))
test3$y  = as.factor(load_label_file("t10k-labels-idx1-ubyte"))

# view test image
show_digit(training3[10000, ])

fit3 <- naiveBayes(y ~ .,data = training3)
test_pred3 = predict(fit3, test3, type="class")
confusionMatrix(test_pred3,test3$y)
