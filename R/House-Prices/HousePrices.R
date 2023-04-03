# Data: HousePrices.xlsx
#Loading required R packages
# Metrics, for remes and mae
install.packages("Metrics")
library(Metrics)

## Splitting data
#sampling
nrow(HousePrices)
nrow(HousePrices)*.7
sampling<-sample(nrow(HousePrices), nrow(HousePrices)*.7)
sampling
dt=sort(sampling)
dt

# or just simply
dt = sort(sample(nrow(HousePrices), nrow(HousePrices)*.7))

#Define training and test data sets
train<-HousePrices[dt,]
test<-HousePrices[-dt,]

# Build a linear regression model
Model1<-lm(Price~.,data=train)
summary(Model1)
observed<-test$Price
predicted<-predict(Model1,test)



# Compute MAE, RMSE, and MAPE  for Model 1
mae.Model1<-mae(observed,predicted)
rmse.Model1<-rmse(observed,predicted)
mape.Model1<-mape(observed,predicted)*100
print(c(mae.Model1,rmse.Model1,mape.Model1))


# Build a linear regression model without offer
Model2<-lm(Price~.,data=train[,-5])
summary(Model2)
observed<-test$Price
predicted<-predict(Model2,test[,-5])



# Compute MAE, RMSE, and MAPE for Model 2
mae.Model2<-mae(observed,predicted)
rmse.Model2<-rmse(observed,predicted)
mape.Model2<-mape(observed,predicted)*100
print(c(mae.Model2,rmse.Model2,mape.Model2))

