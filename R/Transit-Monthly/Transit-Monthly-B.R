# load Metrics to compute RMSE and MAPE
library(Metrics)

attach(Trainsit_Monthly_Data)


# Create a time variable
n<-nrow(Trainsit_Monthly_Data) # length of data
dt1<-data.frame(Trainsit_Monthly_Data, T=c(1:n))



# time series plot
plot(dt1$T,dt1$Trips.month, type="l")
#or use ts.plot function for time series data
ts.plot(dt1$Trips.month)



# Splitting data
nTrain <- n- 12 #length of training data
train<-dt1[1:nTrain,] 
test<-dt1[nTrain+1:12,]
test

## Model 1: Trend model
train.lm.trend<- lm(Trips.month ~ T,data=train)
summary(train.lm.trend)
observed<-test$Trips.month
predicted<-predict(train.lm.trend,test)

#residual plot
plot(resid(train.lm.trend)~fitted(train.lm.trend))
abline(h=0)

# plot data and forecasts
plot(dt1$T,dt1$Trips.month, type="l") 
# plot fitted values in the training period
lines(train.lm.trend$fitted, lwd = 2)
lines(c(nTrain+1:12),predicted, lwd = 2, col="blue")


# compute rmse and mape
rmse.lm.trend<-rmse(observed,predicted)
mape.lm.trend<-mape(observed,predicted)*100
print(c(rmse.lm.trend,mape.lm.trend))



##Model A: Seasonality model

# Create MonthlyIndex
dt1<-data.frame(dt1, MonthlyIndex=dt1$T%%12)


# Splitting data
nTrain <- n- 12 #length of training data
train<-dt1[1:nTrain,] 
test<-dt1[nTrain+1:12,]
test


# build a model on the training data
train.lm.s<- lm(Trips.month~ T+factor(MonthlyIndex),data=train)
summary(train.lm.s)
predicted<-predict(train.lm.s,test)


#residual plot
plot(resid(train.lm.s)~fitted(train.lm.s))
abline(h=0)

# plot data and forecasts
plot(dt1$T,dt1$Trips.month, type="l")
# plot fitted values in the training period
lines(train.lm.s$fitted, lwd = 2)
lines(c(nTrain+1:12),predicted, lwd = 2, col="blue")

# compute rmse and mape
rmse.lm.s <-rmse(observed,predicted)
mape.lm.s <-mape(observed,predicted)*100
print(c(rmse.lm.s,mape.lm.s))


#forecasts
dt1.forecast <-data.frame(T=c(49:60), MonthlyIndex=c(1,2,3,4,5,6,7,8,9,10,11,0))
yearly.forecast<-predict(train.lm.s,dt1.forecast)

print(yearly.forecast)



## Trend, Seasonality and Weather model


#Model B
# build a model on the training data
train.lm.w<- lm(Trips.month~ T+factor(MonthlyIndex)+ Highest.Temperature,data=train)
summary(train.lm.w)
predicted<-predict(train.lm.w,test)


#residual plot
plot(resid(train.lm.s)~fitted(train.lm.w))
abline(h=0)

# plot data and forecasts
plot(dt1$T,dt1$Trips.month, type="l")
# plot fitted values in the training period
lines(train.lm.w$fitted, lwd = 2)
lines(c(nTrain+1:12),predicted, lwd = 2, col="blue")

# compute rmse and mape
rmse.lm.w <-rmse(observed,predicted)
mape.lm.w <-mape(observed,predicted)*100
print(c(rmse.lm.w,mape.lm.w))


#forecasts
dt1.forecast <-data.frame(T=c(49:60), MonthlyIndex=c(1,2,3,4,5,6,7,8,9,10,11,0),
                          Highest.Temperature=c(88,96,96,91,85,72,60,66,70,64,87,92))
yearly.forecast<-predict(train.lm.w,dt1.forecast)

print(yearly.forecast)

