
## Data: Coca_Cola_Data.xlsx
## Build a regression-based time series models

# load Metrics to compute RMSE and MAPE
library(Metrics)

# Create a time variable
n<-nrow(Coca_Cola_Data) # length of data
dt<-data.frame(Coca_Cola_Data, T=c(1:n))
# time series plot
plot(dt$T,dt$Sales, type="l")
#or use ts.plot function for time series data
ts.plot(dt$Sales)

# Splitting data
nTrain <- n- 4 #length of training data
train<-dt[1:nTrain,] 
test<-dt[nTrain+1:4,]
test

## Model 1: Trend model
train.lm.trend<- lm(Sales ~ T,data=train)
summary(train.lm.trend)
observed<-test$Sales
predicted<-predict(train.lm.trend,test)

#residual plot
plot(resid(train.lm.trend)~fitted(train.lm.trend))
abline(h=0)


# plot data and forecasts
plot(dt$T,dt$Sales, type="l") 
# plot fitted values in the training period
lines(train.lm.trend$fitted, lwd = 2)
lines(c(nTrain+1:4),predicted, lwd = 2, col="blue")


# compute rmse and mape
rmse.lm.trend<-rmse(observed,predicted)
mape.lm.trend<-mape(observed,predicted)*100
print(c(rmse.lm.trend,mape.lm.trend))


##Model 2: Seasonality model

# Create QuarterIndex
#Q1=1, Q2=2, Q3=3, Q4=0
dt<-data.frame(dt, QuarterIndex=dt$T%%4)

# Splitting data
nTrain <- n- 4 #length of training data
train<-dt[1:nTrain,] 
test<-dt[nTrain+1:4,]
test

# build a model on the training data
train.lm.s      <- lm(Sales ~ T+factor(QuarterIndex),data=train)
summary(train.lm.s)
predicted<-predict(train.lm.s,test)


#residual plot
plot(resid(train.lm.s)~fitted(train.lm.s))
abline(h=0)

# plot data and forecasts
plot(dt$T,dt$Sales, type="l")
# plot fitted values in the training period
lines(train.lm.s$fitted, lwd = 2)
lines(c(nTrain+1:4),predicted, lwd = 2, col="blue")

# compute rmse and mape
rmse.lm.s <-rmse(observed,predicted)
mape.lm.s <-mape(observed,predicted)*100
print(c(rmse.lm.s,mape.lm.s))


## Model 3: Quadratic model

# Create a time variables
dt<-data.frame(dt, Tsqrd=(dt$T)^2)


# Splitting data
nTrain <- n- 4 #length of training data
train<-dt[1:nTrain,] 
test<-dt[nTrain+1:4,]
test

#Build a model on the training data
train.lm.q      <- lm(Sales ~ T+Tsqrd+factor(QuarterIndex),data=train)
summary(train.lm.q)
predicted<-predict(train.lm.q,test)

#residual plot
plot(resid(train.lm.q)~fitted(train.lm.q))
abline(h=0)

# plot data and forecasts
plot(dt$T,dt$Sales, type="l")
# plot fitted values in the training period
lines(train.lm.q$fitted, lwd = 2)
lines(c(nTrain+1:4),predicted, lwd = 2, col="blue")

# compute rmse and mape
rmse.lm.q <-rmse(observed,predicted)
mape.lm.q <-mape(observed,predicted)*100
print(c(rmse.lm.q,mape.lm.q))


## Model 4: Exponential model
train.lm.exp      <- lm(log(Sales) ~ T+factor(QuarterIndex),data=train)
summary(train.lm.exp)
predicted<-predict(train.lm.exp,test)

#residual plot
plot(resid(train.lm.exp)~fitted(train.lm.exp))
abline(h=0)


# plot data and forecasts
plot(dt$T,dt$Sales, type="l")
# plot fitted values in the training period
lines(exp(train.lm.exp$fitted), lwd = 2)
lines(c(nTrain+1:4),exp(predicted), lwd = 2, col="blue")

# compute rmse and mape in test period
rmse.lm.exp <-rmse(observed,exp(predicted))
mape.lm.exp <-mape(observed,exp(predicted))*100
print(c(rmse.lm.exp,mape.lm.exp))

#forecasts
dt.forecast <-data.frame(T=c(43:46), Tsqrd=c(43:46)^2,QuarterIndex=c(3,0,1,2))
quad.forecast<-predict(train.lm.q,dt.forecast)
exp.forecast<-predict(train.lm.exp,dt.forecast)

print(quad.forecast)
print(exp(exp.forecast))

#plot(c(43:46),quad.forecast,type="l")
#lines(c(43:46),exp(exp.forecast))

      