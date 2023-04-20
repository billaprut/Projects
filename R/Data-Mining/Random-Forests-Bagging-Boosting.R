
#load libraries for ensemble methods
library(randomForest)
library(gbm)

library(ISLR)

set.seed(1)

#we're going to use the OJ dataset (predicting whether a customer prefers Citrus Hill or Minute Maid orange juice)
summary(OJ)
train_inst <- sample(nrow(OJ), .7*nrow(OJ))
train <- OJ[train_inst,]
valid <- OJ[-train_inst,]

##start with random forest
##mtry = number of variables to try at each split 
#set mtry ~= sqrt(17) = 4 
#set 1000 trees (this is something you can tune)
rf.mod <- randomForest(Purchase~.,
                       data=OJ,
                       subset=train_inst,
                       mtry=4, ntree=1000,
                       importance=TRUE)

rf_preds <- predict(rf.mod, newdata=valid)
rf_acc <- mean(ifelse(rf_preds==valid$Purchase,1,0))

rf.mod
rf_acc

#plot the variable importances (the average decrease in impurity when splitting across that variable)
importance(rf.mod)
varImpPlot(rf.mod)


#bagging is just a random forest where mtry=all features
#set mtry=17 (the number of features in the OJ dataset)
bag.mod <- randomForest(Purchase~.,
                        data=OJ,
                        subset=train_inst,
                        mtry=17, #defaults to 500 trees
                        importance=TRUE) 

bag_preds <- predict(bag.mod,newdata=valid)
bag_acc <- mean(ifelse(bag_preds==valid$Purchase,1,0))

bag.mod
bag_acc

##boosting example
boost_data <- OJ

#needs a numerical target variable
boost_data$Purchase <- ifelse(OJ$Purchase=="CH",1,0)
boost_train <- boost_data[train_inst,]
boost_valid <- boost_data[-train_inst,]

boost.mod <- gbm(Purchase~.,data=boost_train,
                 distribution="bernoulli",
                 n.trees=1000,
                 interaction.depth=2)
boost_preds <- predict(boost.mod,newdata=boost_valid,type='response',n.trees=1000)

#classify with a cutoff and compute accuracy
boost_class <- ifelse(boost_preds>.5,1,0)
boost_acc <- mean(ifelse(boost_class==boost_valid$Purchase,1,0))
boost_acc
