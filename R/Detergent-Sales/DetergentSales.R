## DetergentSales.xlsx
attach(DetergentSales)

## Build multiple regression modles

# Model 1: simple regression

Model1<-lm(Qty~Price)
summary(Model1)
plot(Qty~Price)
abline(Model1,col="blue")


# fitted value vs residual plot
plot(resid(Model1)~fitted(Model1))
abline(h=0)
qqnorm(resid(Model1))
qqline(resid(Model1), col="red")
hist(resid(Model1))

# You can also generate a residual plot using plot()
plot(Model1)

# Model 2: Quadratic
Pricesqr<-(Price)^2
Model2<- lm(Qty~Price+Pricesqr)
summary(Model2)

plot(resid(Model2)~fitted(Model2))
abline(h=0)
qqnorm(resid(Model2))
qqline(resid(Model2), col="red")
hist(resid(Model2))

plot(Model2)



# Model 3: Log model
logprice<-log(Price)
Model3<- lm(Qty~logprice)
summary(Model3)

plot(resid(Model3)~fitted(Model3))
abline(h=0)
qqnorm(resid(Model3))
qqline(resid(Model3), col="red")
hist(resid(Model3))

plot(Model3)

# Model 4: Exponential model
logQty<-log(Qty)
Model4<- lm(logQty~Price)
summary(Model4)

plot(resid(Model4)~fitted(Model4))
abline(h=0)
qqnorm(resid(Model4))
qqline(resid(Model4), col="red")
hist(resid(Model4))

plot(Model4)

# Model 5: Log-Log model

Model5<- lm(logQty~logprice)
summary(Model5)
plot(resid(Model5)~fitted(Model5))
abline(h=0)
qqnorm(resid(Model5))
qqline(resid(Model5), col="red")
hist(resid(Model5))

plot(Model5)

# Model 6: Log-Quad model
Model6<- lm(logQty~Price+Pricesqr)
summary(Model6)
plot(resid(Model6)~fitted(Model6))
abline(h=0)
qqnorm(resid(Model6))
qqline(resid(Model6), col="red")
hist(resid(Model6))
