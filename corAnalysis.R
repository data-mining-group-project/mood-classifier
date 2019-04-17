library(lattice)
library(ggplot2)

## Subsetting to keep only the features that we want to test for correlation

corFeatures <- cor(songFeatures[-c(1,2,15)], method = c("pearson", "kendall", "spearman"), 
                   use = 'complete.obs') #remove NAs

# install.packages("corrplot")
library(corrplot)
corrplot(corFeatures, type = "upper")

res1 <- cor.mtest(corFeatures, conf.level = .95)
res2 <- cor.mtest(corFeatures, conf.level = .99)

## specialized the insignificant value according to the significant level
# corrplot(corFeatures, p.mat = res1$p, sig.level = .01, order = "hclust", addrect = 2)
corrplot(corFeatures, sig.level = .01, order = "hclust")


# install.packages("caret")
library(caret)

hc <- findCorrelation(corFeatures, cutoff=0.8, verbose = TRUE)
hc <- sort(hc)
reduced_Data <- corFeatures[,-c(hc)]
reduced_Data

print (reduced_Data)

# at the threshold 0.75, we cann remove energy (col 2), at 0.8 no feature have to be removed

## Reducing the number of variables by removing correlated features

reducedSongFeatures <- songFeatures[-c(1,2, hc + 2)]
