
library(caret)
library(tidyverse)

# Load and process the data
labeled <- read_csv("movies_labeled_clean_2023.csv") %>%
  mutate(IMDB_high = as.factor(IMDB_high),
         genre = as.factor(genre),
         rating = as.factor(rating),
         expensive = as.factor(expensive))


summary(labeled)

# Define two regression formulas
log1formula <- IMDB_high ~ gross + title_year + budget + genre
log2formula <- IMDB_high ~ gross + title_year + budget + genre + rating + expensive

# Do a simple partition of the data into 70% train/30% validation
set.seed(1)
train_insts = sample(nrow(labeled), .7*nrow(labeled))
data_train <- labeled[train_insts,]
data_valid <- labeled[-train_insts,]

# Define a function that trains and predicts probabilities and classifies based on a cutoff c
tr_pred <- function(train_data, valid_data, model_formula){
  trained_model <- glm(data = train_data, model_formula, family = "binomial") 
  predictions <- predict(trained_model, newdata = valid_data, type = "response") 
  return(predictions)
}

# Define a function that uses scores to classify based on a cutoff c
classify <- function(scores, c){
  classifications <- ifelse(scores > c, "YES" , "NO") 
  return(classifications) 
}

probs1 <- tr_pred(data_train, data_valid, log1formula)
classifications1 <- classify(probs1, .5)

probs2 <- tr_pred(data_train, data_valid, log2formula)
classifications2 <- classify(probs2, .5)

###########################################################################
#Section 1: Baseline Models
###########################################################################

# average y value in training data
avg_gross = mean(data_train$gross) 

# fake "model" that always predicts average
# Make a vector that has avg_gross for every row in validation data
baseline_preds = rep(avg_gross, nrow(data_valid)) 

# Evaluate the baseline by computing RMSE vs. actual gross in data_valid
baseline_RMSE = sqrt(mean((baseline_preds - data_valid$gross)^2))

# What do we hope about any model we train to predict the gross revenue?

# Baseline model for categorical Y (for example, IMDB_high):
# (Predict the majority class for every row in validation data)

# Check which is the majority class in the training data
summary(data_train$IMDB_high)

# fake "model" that always predicts majority class
# Make a vector that has the majority class predicted for every row in data_valid
baseline_preds = rep("NO", nrow(data_valid)) 

# Evaluate the baseline "model"
baseline_correct = ifelse(baseline_preds == data_valid$IMDB_high, 1, 0)
baseline_accuracy =  sum(baseline_correct)/length(baseline_correct)

#actuals:
valid_actuals <- data_valid$IMDB_high

#predictions (classifications with cutoff of .5 from before:
valid_classifications <- as.factor(classifications1)

CM_1 = confusionMatrix(data = valid_classifications, #predictions
                     reference = valid_actuals, #actuals
                     positive="YES") #by default, will choose alphabetically first class
CM_1

CM_1$table

TP <- CM_1$table[2,2]

TN <- CM_1$table[1,1]

FP <- CM_1$table[2,1]

FN <- CM_1$table[1,2]

CM_1$overall
CM_1$overall["Accuracy"]
as.numeric(CM_1$overall["Accuracy"])

CM_1$byClass


# TPR = True Positive Rate = Sensitivity = Recall
TPR <- TP/(TP+FN)
as.numeric(CM_1$byClass["Sensitivity"])

# TNR = True Negative Rate = Specificity
TNR <- TN/(TN+FP)
as.numeric(CM_1$byClass["Specificity"])

# FPR = False Positive Rate = 1-TNR
FPR <- 1-TNR

# FNR = False Negative Rate = 1-TPR
FNR = 1-TPR


baseline_preds <- factor(baseline_preds, levels = unique(valid_actuals))
CM_baseline <- confusionMatrix(data = baseline_preds, 
                               reference = valid_actuals,
                               positive = "YES")
CM_baseline

#log1 accuracy
as.numeric(CM_1$overall["Accuracy"])
#baseline accuracy
as.numeric(CM_baseline$overall["Accuracy"])

#log1 TPR
as.numeric(CM_1$byClass["Sensitivity"])
#baseline TPR
as.numeric(CM_baseline$overall["Sensitivity"])

#log1 TNR
as.numeric(CM_1$byClass["Specificity"])
#baseline TNR
as.numeric(CM_baseline$byClass["Specificity"])

###########################################################################
#Section 2b: Cutoffs
###########################################################################

# Make a confusion matrix given a low cutoff
predicted_classes_lowcutoff <- factor(classify(probs1, .1), 
                                      levels = unique(valid_actuals))

confusionMatrix(data = predicted_classes_lowcutoff, 
                            reference = valid_actuals,
                            positive = "YES")

# Make a confusion matrix given a higher cutoff
predicted_classes_highcutoff <- factor(classify(probs1, .6), 
                                       levels = unique(valid_actuals))

confusionMatrix(data = predicted_classes_highcutoff, 
                reference = valid_actuals,
                positive = "YES")

# Make vectors of 0s to store results
cutoffs <- rep(0,100)
accs <- rep(0,100)
tprs <- rep(0,100)
tnrs <- rep(0,100)

#for each cutoff
for (c in c(0:100)){
  cutoff <- c*.01
  
  #classify given the cutoff
  predicted_classes <- classify(probs1, cutoff)
  predicted_classes <- factor(predicted_classes, levels = unique(valid_actuals))
  
  #make the confusion matrix

  conf_mat <- confusionMatrix(data = predicted_classes, 
                              reference = valid_actuals,
                              positive = "YES")
  
  #print(conf_mat)
  
  TP <- conf_mat$table[2,2]
  TN <- conf_mat$table[1,1]
  FP <- conf_mat$table[2,1]
  FN <- conf_mat$table[1,2]
  
  accuracy <- as.numeric(conf_mat$overall["Accuracy"])
  TPR <- TP/(TP+FN)
  TNR <- TN/(TN+FP)
  
  #save the metrics in the vectors we made
  cutoffs[c] <- cutoff
  accs[c] <- accuracy
  tprs[c] <- TPR
  tnrs[c] <- TNR
  
}

#you can use a simple plot() to make a scatterplot
plot(cutoffs, accs, type="o", col="blue", ylim=c(0,1))

#to add more series to the same plot, use points() or lines()
points(cutoffs, tprs, col="red")
points(cutoffs, tnrs, col="green")

#adds a legend
#the first two arguments are the x and y coordinates of the legend
legend(.4, .2, legend = c("Accuracy", "TPR", "TNR"), col = c("blue", "red", "green"), lty = 1)



###########################################################################
#Section 3: Cost Matrices
###########################################################################

# Let's make a cost matrix function
make_cost_matrix <- function(TN_cost, FP_cost, FN_cost, TP_cost){
  
  cost_matrix = matrix(c(TN_cost, FP_cost, FN_cost, TP_cost), nrow=2)
  return(cost_matrix)  
}

#create a cost matrix
sample_cost_matrix <- make_cost_matrix(0, 10, 0, -90)
sample_cost_matrix

# Here's the confusion matrix from logistic model 1
CM_1$table


#to compute the total cost, just take the product of the two matrices and sum
log1_cost <- sum(CM_1$table*sample_cost_matrix)
log1_cost
