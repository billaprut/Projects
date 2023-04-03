
# Objective: conduct model selection to best predict IMDB_high

library(tidyverse)

labeled <- read_csv("movies_labeled_clean_2023.csv")

# I have added a new categorical target variable: IMDB_high
# IMDB_high = "YES" (positive class) if the average score was at least 7
# Goal is to predict IMDB_high

summary(labeled)

# Make sure our factors are actually factors
labeled <- labeled %>%
  mutate(IMDB_high = as.factor(IMDB_high),
         genre = as.factor(genre),
         rating = as.factor(rating),
         expensive = as.factor(expensive))
  
summary(labeled)


# Review: eval for inference
# We learn parameters and evaluate on the whole set of labeled data

# Train a logistic regression model and look at the goodness-of-fit
#define a variable for the model specification (different from the learned parameters)
log1formula <- IMDB_high ~ gross + title_year + budget + genre 

log_model1 <- glm(log1formula, data = labeled, family = "binomial")
summary(log_model1)

#let's compare it to a second model
log2formula <- IMDB_high ~ gross + title_year + budget + genre + rating
log_model2 <- glm(log2formula, data = labeled, family = "binomial")
summary(log_model2)


# simple train-valid split
set.seed(1)

#sample(max, n) will randomly select n instances from a list spanning from 1 to max
train_insts = sample(nrow(labeled), .7*nrow(labeled))

#separate labeled data into training and validation 
data_train <- labeled[train_insts,]
data_valid <- labeled[-train_insts,]

# Given a model specification and training/validation data, there are four main steps:

# 1. Train
trained_model1 <- glm(data = data_train, log1formula, family = "binomial") 

# 2. Predict (note the type = "response")
predictions1 <- predict(trained_model1, newdata = data_valid, type = "response") 

# 3. Classify
classifications1 <- ifelse(predictions1 > .5, "YES" , "NO") 

# 4. Evaluate
#assess if the predictions match the actual values or not, then calculate the accuracy
correct_classifications1 <- ifelse(classifications1 == data_valid$IMDB_high, 1, 0) 
accuracy1 = sum(correct_classifications1)/length(correct_classifications1) 

# We could also put these steps into a function so that our code can be reused

tr_pred_eval <- function(train_data, valid_data, model_formula){
  trained_model <- glm(data = train_data, model_formula, family = "binomial") 
  predictions <- predict(trained_model, newdata = valid_data, type = "response") 
  classifications <- ifelse(predictions > .5, "YES" , "NO") 
  correct_classifications <- ifelse(classifications == valid_data$IMDB_high, 1, 0) 
  accuracy = sum(correct_classifications)/length(correct_classifications) 
  return(accuracy) 
}

#compute the validation accuracy for the two model specifications
log1acc <- tr_pred_eval(data_train, data_valid, log1formula) 
log2acc <- tr_pred_eval(data_train, data_valid, log2formula)
