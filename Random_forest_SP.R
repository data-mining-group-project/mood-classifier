# testing random florest 
library(randomForest)
library(partykit)
library(caret)
library(tree)

set.seed(2)
R<-nrow(Spotify)
S_train <-sample(1:N,size=0.75*R)
RF_train <- Spotify[S_train, ]
RF_test <- Spotify[- S_train, ] 


fit <- randomForest(label ~ ., data = RF_train)
varImpPlot(fit)
plot(fit)

err <- fit$err.rate
legend(x = "right", 
       legend = colnames(err),
       fill = 1:ncol(err))

# Create the predicted label 

prediction <- predict(fit, newdata = RF_test , type = "class")

matrix <- confusionMatrix(prediction, reference = RF_test$label)
matrix

#####################################################################
# Tuning  Forest based on OOB

# Establish a list of possible values for mtry, nodesize and sampsize
mtry <- seq(4, ncol(RF_train) * 0.8, 2)
nodesize <- seq(3, 8, 2)
sampsize <- nrow(RF_train) * c(0.7, 0.8)

# Create a data frame containing all combinations 
hyper_grid <- expand.grid(mtry = mtry, nodesize = nodesize, sampsize = sampsize)

# Create an empty vector to store OOB error values
oob_err <- c()

# Write a loop over the rows of hyper_grid to train the grid of models
for (i in 1:nrow(hyper_grid)) {
  
  # Train a Random Forest model
  model <- randomForest(formula = label ~ ., 
                        data = RF_train,
                        mtry = hyper_grid$mtry[i],
                        nodesize = hyper_grid$nodesize[i],
                        sampsize = hyper_grid$sampsize[i])
  
  # Store OOB error for the model                      
  oob_err[i] <- model$err.rate[nrow(model$err.rate), "OOB"]
}

# Identify optimal set of hyperparmeters based on OOB error
opt_i <- which.min(oob_err)
print(hyper_grid[opt_i,])



# Run the ideal model

Best_model <- randomForest(formula = label ~ ., 
                      data = RF_train,
                      mtry = 4,
                      nodesize = 7,
                      sampsize = 4607)

plot(Best_model)


Best_prediction <- predict(Best_model, newdata = RF_test , type = "class")

matrix <- confusionMatrix(Best_prediction, reference = RF_test$label)
matrix


#######################################################################


library(AppliedPredictiveModeling)
transparentTheme(trans = .4)
library(caret)
featurePlot(x = Spotify_mood[, 2:12], 
            y = Spotify_mood$label, 
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = 3))


saveRDS(object = Best_model, file = "mod_rf.rds")
