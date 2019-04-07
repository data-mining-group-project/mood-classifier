##############################################################
#Dealing with Multicollinearity and choose variables to use
#Identify correlation between variables 
#Remove highly correlated variables
##############################################################
#Read songs featuers csv
songs_features <- read.csv(file = "songFeatures.csv", header = TRUE, sep = ",")
#Subset file to keep only songs feature columns
features <- songs_features[4:15]
#Identify correlation between features
cor(features[,unlist(lapply(features, is.numeric))], use = 'complete.obs')
#Plot correlation
install.packages("corrplot")
library(corrplot)
M <- cor(features[,unlist(lapply(features, is.numeric))], use = 'complete.obs')
corrplot(M, type="upper")
#Choose variables to keep by using function findCorrelation
install.packages("caret")
library(caret)
findCorrelation(M, cutoff = 0.5, verbose = FALSE, names = TRUE, exact = ncol(M) <100)
#Remove highly correlated features
N <- features[-c(2,7)]
cor_N <- cor(N[,unlist(lapply(N, is.numeric))], use = 'complete.obs')
#Plot correlation
corrplot(cor_N, type = "upper")