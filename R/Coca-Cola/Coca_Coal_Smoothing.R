## Data: Coca_Cola.xlsx
## Build exponential time series models

install.packages("forecast")
library(forecast)

# load Metrics to compute RMSE and MAPE
library(Metrics)

# store the data in a time series object
CocaCola.ts <- ts(Coca_Cola_Data$Sales, start = c(1986, 1), frequency = 4)
# create a time series plot
plot(CocaCola.ts)

CocaCola.ts

# split data
train.ts <- window(CocaCola.ts, start = c(1986, 1), end = c(1995,2))
test.ts <- window(CocaCola.ts, start =  c(1995,3))

#########################################
## Simple Exponential Smoothing Method ##
#########################################

# turn off beta and gamma. alpha is in auto mode
train.simple <- HoltWinters(train.ts, beta=FALSE, gamma=FALSE)
# summary
train.simple

# alpha = 0.1
train.simple <- HoltWinters(train.ts, alpha=0.1,beta=FALSE, gamma=FALSE)
train.simple

# Forecast for test period + forecast period
simple.pred <- forecast(train.simple, h=8, level=0)
simple.pred 

# plot data and fitted values in training period
# version 1
plot(train.simple,ylab = "Sales",type='l',xlab = "Quaters",xlim=c(1986,1997),ylim= c(0,6000))
lines(test.ts)
lines(simple.pred$mean,col="blue") 

#version 2
# plot data and fitted values in training period
plot(simple.pred,ylab = "Sales",type='l',xlab = "Quaters")
lines(test.ts)
lines(simple.pred$fitted,col="red") 

# compute rmse and mape in test period
print(c(rmse(test.ts,simple.pred$mean), mape(test.ts,simple.pred$mean)))


## If forecast function does not work, use predict function
simple.pred <- predict(train.simple, 8)

#Visually evaluate the prediction
plot(train.simple,ylab = "Sales",type='l',xlab = "Quaters",xlim=c(1986,1997),ylim=c(0,6000))
lines(test.ts)
lines(simple.pred,col="blue") 

# compute rmse and mape in test period
print(c(rmse(test.ts,simple.pred), mape(test.ts,simple.pred)))



########################################################
## Holt's Method (Double Exponential Smoothing Model) ##
########################################################

# turn off gamma. alpha and beta are in auto mode
train.Holt <- HoltWinters(train.ts, gamma=FALSE)
# summary
train.Holt

# alpha =0.2, beta = 0.15
train.Holt <- HoltWinters(train.ts, alpha=0.2,beta=0.15, gamma=FALSE)
train.Holt

# Forecast for test period + forecast period
Holt.pred <- forecast(train.Holt, h=8, level=0)

# plot data and fitted values in training period
# version 1
plot(train.Holt,ylab = "Sales",type='l',xlab = "Quaters",xlim=c(1986,1997),ylim=c(0,6000))
lines(test.ts)
lines(Holt.pred$mean,col="blue") 

#version 2
plot(Holt.pred,ylab = "Sales",bty='l',xlab = "Quaters")
lines(test.ts)
lines(Holt.pred$fitted,col="red") 


###########################################################
## Holt-Winter's Method (Triple Exponential Smoothing Model) ##
###############################################################


# turn off gamma. alpha and beta are in auto mode
train.Winter <- HoltWinters(train.ts, seasonal="multiplicative" )
# summary
train.Winter

# alpha =0.2, beta = 0.15, gamma = 0.1
train.Winter <- HoltWinters(train.ts, alpha=0.3,beta=0.25, gamma=0.2,seasonal="multiplicative")
train.Winter

# Forecast for test period + forecast period
Winter.pred <- forecast(train.Winter, h=8, level=0)

# plot data and fitted values in training period
# version 1
plot(train.Winter,ylab = "Sales",type='l',xlab = "Quaters",ylim= c(0,6000), xlim=c(1986,1997))
lines(test.ts)
lines(Winter.pred$mean,col="blue") 

#version 2
plot(Winter.pred,ylab = "Sales",type='l',xlab = "Quaters")
lines(test.ts)
lines(Winter.pred$fitted,col="red") 


# compute rmse and mape in test period
print(c(rmse(test.ts,Winter.pred$mean), mape(test.ts,Winter.pred$mean)*100))



