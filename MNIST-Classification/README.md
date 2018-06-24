
**Dataset**

The MNIST dataset is a dataset of 60,000 training and 10,000 test examples of handwritten digits, originally constructed by Yann Lecun, Corinna Cortes, and Christopher J.C. Burges. It is very widely used to check several methods. There are 10 classes in total ("0" to "9"). This dataset has been extensively studied, and there is a history of methods and feature construc- tions at https://en.wikipedia.org/wiki/MNIST_database and at the original site, http://yann.lecun.com/exdb/mnist/ . Please note that the best methods perform extremely well.

There is also a version of the data that was used for a Kaggle competition. This can be used as well for convenience so there would not be a need decompress Lecun's original format. It can be found at http://www.kaggle.com/c/digit-recognizer .

I used the original MNIST data files from http://yann.lecun.com/exdb/mnist/ , the dataset is stored in an unusual format, described in detail on the page. If the original dataset is being used then please begin by reading over the technical details. I built my own reader using the standard packages to read the binary files. Please note that in the readBin call the flag signed should bet set to FALSE since the data values are stored as unsigned integers. For additional reference, there is reader code in MATLAB available at http://ufldl.stanford.edu/wiki/index.php/Using_the_MNIST_Dataset .

Regardless of the format of the dataset, it consists of 28 x 28 images. These were originally binary images, but appear to be grey level images as a result of some anti-aliasing. I ignored mid grey pixels (there aren't many of them) and called dark pixels "ink pixels", and light pixels "paper pixels"; we can modify the data values with a threshold to specify the distinction, as described here https://en.wikipedia.org/wiki/Thresholding_(image_processing) . The digit has been centered in the image by centering the center of gravity of the image pixels, but as mentioned on the original site, this is probably not ideal. Here are some options I explored for re-centering the digits that I will refer to in the individual sections.

  + Untouched: Do not re-center the digits, but use the images as is.
  + Bounding box: Construct a 20 x 20 bounding box so that the horizontal (resp. vertical) range of ink pixels is centered in
    the box.
  + Stretched bounding box: Construct a 20 x 20 bounding box so that the horizontal (resp. vertical) range of ink pixels runs
    the full horizontal (resp. vertical) range of the box. Obtaining this representation will involve rescaling image pixels:
    we can find the horizontal and vertical ink range, cut that out of the original image, then resize the result to 20 x 20.
    Once the image has been re-centered, we can compute features.

Here are some pictures, which may help

<img src="/MNIST-Classification/bouding_v2.png">

**Homework1 Problem2 – Part A**

Based on the table below, Gaussian distribution seem to have performed better for Stretched images and Bernoulli distribution for untouched image pixels.

| Accuracy | Gaussian | Bernoulli |
| --- | --- | --- |
| Untouched images (20x20) | 0.4849 | 0.831 |
| Untouched images as is (28x28) | 0.5352 | 0.8413 |
| Stretched bounding box | 0.8285 | 0.78 |

**Homework1 Problem2 – Part B**

The number of trees and depth seem to have an impact on accuracy. As the number of trees and depth increase, the accuracy looks to be increasing.

Untouched raw pixels cropped to 20x20:

|   | Depth = 4 | Depth = 8 | Depth = 16 |
| --- | --- | --- | --- |
| #trees = 10 | 0.8296 | 0.9266 | 0.9521 |
| #trees = 20 | 0.8533 | 0.9293 | 0.9615 |
| #trees = 30 | 0.8603 | 0.9335 | 0.9614 |

Untouched raw pixels as is 28x28:

|   | Depth = 4 | Depth = 8 | Depth = 16 |
| --- | --- | --- | --- |
| #trees = 10 | 0.8511 | 0.9322 | 0.9569 |
| #trees = 20 | 0.8654 | 0.9371 | 0.9628 |
| #trees = 30 | 0.8695 | 0.9399 | 0.9659 |

Stretched bounding box:

|   | Depth = 4 | Depth = 8 | Depth = 16 |
| --- | --- | --- | --- |
| #trees = 10 | 0.8553 | 0.9426 | 0.9574 |
| #trees = 20 | 0.8582 | 0.9442 | 0.9667 |
| #trees = 30 | 0.8655 | 0.9469 | 0.9685 |



**Appendix - Confusion Matrix for Problem 2 Part A**

**Confusion Matrix and Statistics - Naive Bayes Normal 20 x 20 bounding**

          Reference

Prediction    0    1    2    3    4    5    6    7    8    9

         0  924    0  183  118   77  132   70   24   23   22

         1    0 1078   31   41   13   31   25   17   81   17

         2    3    0  133    2    4    1    0    1    2    3

         3    0    0   53  217    3    6    2    7    4    4

         4    0    0    0    1   58    0    1    2    2    0

         5    1    0    2    2    2   21    5    0    2    0

         6    5    3  106   10   24    5  611    3    1    0

         7    0    0    0    1    2    1    0  119    0    2

         8   46   52  517  577  504  655  243  215  825   98

         9    1    2    7   41  295   40    1  640   34  863

Overall Statistics

               Accuracy : 0.4849

                 95% CI : (0.4751, 0.4947)

    No Information Rate : 0.1135

    P-Value [Acc &gt; NIR] : &lt; 2.2e-16

                  Kappa : 0.4274

 Mcnemar&#39;s Test P-Value : NA

Statistics by Class:

                     Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6

Sensitivity            0.9429   0.9498   0.1289   0.2149  0.05906  0.02354   0.6378

Specificity            0.9280   0.9711   0.9982   0.9912  0.99933  0.99846   0.9826

Pos Pred Value         0.5874   0.8081   0.8926   0.7331  0.90625  0.60000   0.7956

Neg Pred Value         0.9934   0.9934   0.9087   0.9183  0.90700  0.91259   0.9624

Prevalence             0.0980   0.1135   0.1032   0.1010  0.09820  0.08920   0.0958

Detection Rate         0.0924   0.1078   0.0133   0.0217  0.00580  0.00210   0.0611

Detection Prevalence   0.1573   0.1334   0.0149   0.0296  0.00640  0.00350   0.0768

Balanced Accuracy      0.9355   0.9605   0.5635   0.6030  0.52920  0.51100   0.8102

                     Class: 7 Class: 8 Class: 9

Sensitivity            0.1158   0.8470   0.8553

Specificity            0.9993   0.6779   0.8820

Pos Pred Value         0.9520   0.2211   0.4485

Neg Pred Value         0.9079   0.9762   0.9819

Prevalence             0.1028   0.0974   0.1009

Detection Rate         0.0119   0.0825   0.0863

Detection Prevalence   0.0125   0.3732   0.1924

Balanced Accuracy      0.5575   0.7625   0.8686



**Confusion Matrix and Statistics - Naive Bayes Bernoulli 20 x 20 bounding**

          Reference
Prediction    0    1    2    3    4    5    6    7    8    9
         0  902    0   22    7    5   30   28    1   17   12
         1    0 1073    9   19    5   11   18   25   15   16
         2    3   10  835   41    4    7   13   21   10    6
         3   10   10   40  834    1  143    2    3   83    9
         4    0    0   12    4  762   19   12   13   13   62
         5   22    6    6   13    6  591   36    0   11    6
         6   12    5   39    5   25   17  837    0    5    1
         7    2    0   13   13    2   11    0  858    7   29
         8   29   30   54   47   34   39   12   24  777   27
         9    0    1    2   27  138   24    0   83   36  841

Overall Statistics

               Accuracy : 0.831
                 95% CI : (0.8235, 0.8383)
    No Information Rate : 0.1135
    P-Value [Acc &gt; NIR] : &lt; 2.2e-16

                  Kappa : 0.8121
 Mcnemar&#39;s Test P-Value : NA

Statistics by Class:

                                   Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6 Class: 7 Class: 8 Class: 9

Sensitivity            0.9204   0.9454   0.8091   0.8257   0.7760   0.6626   0.8737   0.8346   0.7977   0.8335

Specificity            0.9865   0.9867   0.9872   0.9665   0.9850   0.9884   0.9879   0.9914   0.9672   0.9654

Pos Pred Value         0.8809   0.9009   0.8789   0.7348   0.8495   0.8479   0.8848   0.9176   0.7241   0.7300

Neg Pred Value         0.9913   0.9930   0.9782   0.9801   0.9758   0.9676   0.9866   0.9812   0.9779   0.9810

Prevalence             0.0980   0.1135   0.1032   0.1010   0.0982   0.0892   0.0958   0.1028   0.0974   0.1009

Detection Rate         0.0902   0.1073   0.0835   0.0834   0.0762   0.0591   0.0837   0.0858   0.0777   0.0841

Detection Prevalence   0.1024   0.1191   0.0950   0.1135   0.0897   0.0697   0.0946   0.0935   0.1073   0.1152

Balanced Accuracy      0.9534   0.9660   0.8981   0.8961   0.8805   0.8255   0.9308   0.9130   0.8825   0.8995

**Confusion Matrix and Statistics - Naive Bayes Normal 20 x 20 bounding with autocrop**

          Reference

Prediction   0   1   2   3   4   5   6   7   8   9

         0 938   3  18   6   3  17  14   0  10   5

         1   1 922  18   9  24  12  12  51  44  15

         2   3  43 826  24   5   5   8  39  30   7

         3   3   1  10 867   0  71   2  11  12   9

         4   5  32   5   2 814   8  40  15  15  49

         5   6  16  15  28   8 702  17   6  29   7

         6  11  19  14   0  26  22 848   0   9   0

         7   0  58  56  20   2   4   0 829  12  17

         8   9  30  58  36  17  23  14  17 686  47

         9   4  11  12  18  83  28   3  60 127 853

Overall Statistics

               Accuracy : 0.8285

                 95% CI : (0.821, 0.8358)

    No Information Rate : 0.1135

    P-Value [Acc &gt; NIR] : &lt; 2.2e-16

                  Kappa : 0.8094

 Mcnemar&#39;s Test P-Value : NA

Statistics by Class:

                     Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6

Sensitivity            0.9571   0.8123   0.8004   0.8584   0.8289   0.7870   0.8852

Specificity            0.9916   0.9790   0.9817   0.9868   0.9810   0.9855   0.9888

Pos Pred Value         0.9250   0.8321   0.8343   0.8793   0.8264   0.8417   0.8936

Neg Pred Value         0.9953   0.9760   0.9771   0.9841   0.9814   0.9793   0.9878

Prevalence             0.0980   0.1135   0.1032   0.1010   0.0982   0.0892   0.0958

Detection Rate         0.0938   0.0922   0.0826   0.0867   0.0814   0.0702   0.0848

Detection Prevalence   0.1014   0.1108   0.0990   0.0986   0.0985   0.0834   0.0949

Balanced Accuracy      0.9744   0.8957   0.8911   0.9226   0.9050   0.8863   0.9370

                     Class: 7 Class: 8 Class: 9

Sensitivity            0.8064   0.7043   0.8454

Specificity            0.9812   0.9722   0.9615

Pos Pred Value         0.8307   0.7321   0.7114

Neg Pred Value         0.9779   0.9682   0.9823

Prevalence             0.1028   0.0974   0.1009

Detection Rate         0.0829   0.0686   0.0853

Detection Prevalence   0.0998   0.0937   0.1199

Balanced Accuracy      0.8938   0.8383   0.9035



**Confusion Matrix and Statistics - Naive Bayes Bernoulli 20 x 20 bounding with autocrop**

          Reference

Prediction   0   1   2   3   4   5   6   7   8   9

         0 953   1  40  10   3  26  24   3  13   5

         1  11 791  54  28  79  59  52 148  69  29

         2   0  39 784  16   2   3   2  20   5   4

         3   4  12  14 876   0 119   2  16  17   8

         4   1  22   2   1 729   5   7  11   0  27

         5   0   7   1   6   1 526   4   1   6   2

         6   4  24  23   4  31  39 862   0   7   0

         7   0  10  19   4   0   1   0 685   5   6

         8   5 223  86  57  19  84   4  43 776 110

         9   2   6   9   8 118  30   1 101  76 818

Overall Statistics

               Accuracy : 0.78

                 95% CI : (0.7717, 0.7881)

    No Information Rate : 0.1135

    P-Value [Acc &gt; NIR] : &lt; 2.2e-16

                  Kappa : 0.7554

 Mcnemar&#39;s Test P-Value : NA

Statistics by Class:

                     Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6

Sensitivity            0.9724   0.6969   0.7597   0.8673   0.7424   0.5897   0.8998

Specificity            0.9861   0.9403   0.9899   0.9786   0.9916   0.9969   0.9854

Pos Pred Value         0.8840   0.5992   0.8960   0.8202   0.9056   0.9495   0.8672

Neg Pred Value         0.9970   0.9604   0.9728   0.9850   0.9725   0.9613   0.9893

Prevalence             0.0980   0.1135   0.1032   0.1010   0.0982   0.0892   0.0958

Detection Rate         0.0953   0.0791   0.0784   0.0876   0.0729   0.0526   0.0862

Detection Prevalence   0.1078   0.1320   0.0875   0.1068   0.0805   0.0554   0.0994

Balanced Accuracy      0.9793   0.8186   0.8748   0.9230   0.8670   0.7933   0.9426

                     Class: 7 Class: 8 Class: 9

Sensitivity            0.6663   0.7967   0.8107

Specificity            0.9950   0.9301   0.9610

Pos Pred Value         0.9384   0.5515   0.6997

Neg Pred Value         0.9630   0.9770   0.9784

Prevalence             0.1028   0.0974   0.1009

Detection Rate         0.0685   0.0776   0.0818

Detection Prevalence   0.0730   0.1407   0.1169

Balanced Accuracy      0.8307   0.8634   0.8858

**Confusion Matrix and Statistics - Naive Bayes Normal 28 x 28 bounding**

          Reference

Prediction    0    1    2    3    4    5    6    7    8    9

         0  862    0   94   40   22   69   16    2   13    8

         1    0 1081   24   33    2   25   13   14   67    7

         2    1    1  212    4    2    1    2    0    4    1

         3    3    0   87  310    0   19    0    7    6    5

         4    3    0    2    1  131    2    1    8    2    0

         5    4    0    2    4    4   35    4    2    7    0

         6   31   10  284   59   66   39  890    5   13    2

         7    1    0    5    7    7    1    0  228    3    3

         8   44   36  298  437  188  592   27   49  642   22

         9   31    7   24  115  560  109    5  713  217  961

Overall Statistics

               Accuracy : 0.5352

                 95% CI : (0.5254, 0.545)

    No Information Rate : 0.1135

    P-Value [Acc &gt; NIR] : &lt; 2.2e-16

                  Kappa : 0.4832

 Mcnemar&#39;s Test P-Value : NA

Statistics by Class:

                     Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6

Sensitivity            0.8796   0.9524   0.2054   0.3069   0.1334  0.03924   0.9290

Specificity            0.9707   0.9791   0.9982   0.9859   0.9979  0.99704   0.9437

Pos Pred Value         0.7655   0.8539   0.9298   0.7094   0.8733  0.56452   0.6362

Neg Pred Value         0.9867   0.9938   0.9161   0.9268   0.9136  0.91377   0.9921

Prevalence             0.0980   0.1135   0.1032   0.1010   0.0982  0.08920   0.0958

Detection Rate         0.0862   0.1081   0.0212   0.0310   0.0131  0.00350   0.0890

Detection Prevalence   0.1126   0.1266   0.0228   0.0437   0.0150  0.00620   0.1399

Balanced Accuracy      0.9252   0.9658   0.6018   0.6464   0.5656  0.51814   0.9364

                     Class: 7 Class: 8 Class: 9

Sensitivity            0.2218   0.6591   0.9524

Specificity            0.9970   0.8124   0.8019

Pos Pred Value         0.8941   0.2749   0.3505

Neg Pred Value         0.9179   0.9567   0.9934

Prevalence             0.1028   0.0974   0.1009

Detection Rate         0.0228   0.0642   0.0961

Detection Prevalence   0.0255   0.2335   0.2742

Balanced Accuracy      0.6094   0.7358   0.8772



**Confusion Matrix and Statistics - Naive Bayes Bernoulli 28 x 28 bounding**

          Reference

Prediction    0    1    2    3    4    5    6    7    8    9

         0  887    0   19    5    2   23   18    1   16    9

         1    0 1085    8   15    6   12   18   24   23   13

         2    4   10  852   34    4    7   15   14   13    5

         3    7    5   29  844    0  129    2    4   76    9

         4    2    0   17    0  795   30   13   15   17   74

         5   41    9    4   13    4  627   35    0   22    8

         6   16    6   32    9   21   16  851    0    7    0

         7    1    0   14   15    1    8    0  871    6   24

         8   22   19   55   49   23   21    6   27  758   24

         9    0    1    2   26  126   19    0   72   36  843

Overall Statistics

               Accuracy : 0.8413

                 95% CI : (0.834, 0.8484)

    No Information Rate : 0.1135

    P-Value [Acc &gt; NIR] : &lt; 2.2e-16

                  Kappa : 0.8236

 Mcnemar&#39;s Test P-Value : NA

Statistics by Class:

                     Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6

Sensitivity            0.9051   0.9559   0.8256   0.8356   0.8096   0.7029   0.8883

Specificity            0.9897   0.9866   0.9882   0.9710   0.9814   0.9851   0.9882

Pos Pred Value         0.9051   0.9012   0.8894   0.7638   0.8255   0.8218   0.8883

Neg Pred Value         0.9897   0.9943   0.9801   0.9813   0.9793   0.9713   0.9882

Prevalence             0.0980   0.1135   0.1032   0.1010   0.0982   0.0892   0.0958

Detection Rate         0.0887   0.1085   0.0852   0.0844   0.0795   0.0627   0.0851

Detection Prevalence   0.0980   0.1204   0.0958   0.1105   0.0963   0.0763   0.0958

Balanced Accuracy      0.9474   0.9713   0.9069   0.9033   0.8955   0.8440   0.9382

                     Class: 7 Class: 8 Class: 9

Sensitivity            0.8473   0.7782   0.8355

Specificity            0.9923   0.9727   0.9686

Pos Pred Value         0.9266   0.7550   0.7493

Neg Pred Value         0.9827   0.9760   0.9813

Prevalence             0.1028   0.0974   0.1009

Detection Rate         0.0871   0.0758   0.0843

Detection Prevalence   0.0940   0.1004   0.1125

Balanced Accuracy      0.9198   0.8755   0.9021

