library(tidyverse)
library(caret) #need this for dummyVars()

# define a function to calculate accuracy
accuracy <- function(classifications, actuals){
  correct_classifications <- ifelse(classifications == actuals, 1, 0)
  acc <- sum(correct_classifications)/length(classifications)
  return(acc)
}

# Load a smaller version of the movies data
# Turn all factors into factors
movies <- read_csv("movies_cleaned_small.csv") %>%
  mutate(IMDB_high = as.factor(IMDB_high),
         genre = as.factor(genre))

summary(movies)
library(class)
movies_y <- movies$IMDB_high

movies_features <- movies %>%
  select(gross, budget, title_year, genre)

# "Learn" the various dummy variable values (aka the values that each factor can be)
dummy <- dummyVars( ~ . , data=movies_features, fullRank = TRUE)

# Apply the learned dummy parameterization to the original data to turn it into dummy variables
movies_X <- data.frame(predict(dummy, newdata = movies_features)) 


##Split the data into training and validation data
set.seed(1)

## Partition 30% of the data as validation data
valid_instn = sample(nrow(movies), 0.30*nrow(movies))

# partition the features into training and validation rows
train_X <- movies_X[-valid_instn,]
valid_X <- movies_X[valid_instn,]

# partition the target variable into training and validation rows
train_y <- movies_y[-valid_instn]
valid_y <- movies_y[valid_instn]

# Let's make predictions in the validation data

knn.pred=knn(train_X, #the training instances' features
             valid_X, #the new instances we want to make predictions for
             train_y, #the y values in the training data
             k=5, #choose k
             prob = TRUE) #get probabilities as well
knn.pred

table(valid_y,knn.pred)
accuracy(knn.pred, valid_y)

knn.probs <- attr(knn.pred, "prob")
knn.probs
knn_probofYES <- ifelse(knn.pred == "YES", knn.probs, 1-knn.probs)
knn_probofYES

# Now we could classify with a different cutoff

knn_class.6 <- ifelse(knn_probofYES >= 0.6, "YES", "NO")
accuracy.6 <- accuracy(knn_class.6, valid_y)

kvec <- c(1:50)*2 - 1 #every odd number between 1 and 100
kvec

#initialize storage
va_acc <- rep(0, length(kvec))
tr_acc <- rep(0, length(kvec))

#for loop
for(i in 1:length(kvec)){
  inner_k <- kvec[i]

  inner_tr_preds <- knn(train_X, train_X, train_y, k=inner_k, prob = TRUE) 
  inner_tr_acc <- accuracy(inner_tr_preds, train_y)
  tr_acc[i] <- inner_tr_acc
  
  #now repeat for predictions in the validation data
  inner_va_preds <- knn(train_X, valid_X, train_y, k=inner_k, prob = TRUE) 
  inner_va_acc <- accuracy(inner_va_preds, valid_y)
  va_acc[i] <- inner_va_acc
  
}

plot(kvec, tr_acc, col = "blue", type = 'l', ylim = c(.6,1))
lines(kvec, va_acc, col = "red")


best_validation_index <- which.max(va_acc) #tells us the index of the first occurence of the highest value in a vector
best_k <- kvec[best_validation_index] #tells us the k that has that index

#make predictions with the best k (for me it was 33) and retrieve the probability that Y=1
best_k_preds <- knn(train_X, valid_X, train_y, best_k, prob=TRUE)
best_probs <- attr(best_k_preds, "prob")
best_probofYES <- ifelse(best_k_preds == "YES", best_probs, 1-best_probs)

#made a function to classify given a cutoff and assess accuracy, TPR, and TNR
classify_evaluate <- function(predicted_probs, actual_y, cutoff){

  classifications <- ifelse(predicted_probs > cutoff, "YES", "NO")
  classifications <- factor(classifications, levels = levels(actual_y))
  
  CM <- confusionMatrix(data = classifications,
                            reference = actual_y,
                            positive = "YES")
  
  CM_accuracy <- as.numeric(CM$overall["Accuracy"])
  CM_TPR <- as.numeric(CM$byClass["Sensitivity"])
  CM_TNR <- as.numeric(CM$byClass["Specificity"])
  
  return(c(CM_accuracy, CM_TPR, CM_TNR))
  
}

#print the performance for each cutoff
classify_evaluate(best_probofYES, valid_y, .25)
classify_evaluate(best_probofYES, valid_y, .5)
classify_evaluate(best_probofYES, valid_y, .75)

