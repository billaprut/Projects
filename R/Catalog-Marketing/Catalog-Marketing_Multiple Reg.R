## Multiple Linear Regression
## Data: Catalog_Marketing_Reg.xlsx 

attach(Catalog_Marketing_Reg)


Model1 <- lm(AmountSpent~Salary+factor(Gender))
summary(Model1)

plot(resid(Model1)~fitted(Model1))
abline(h=0)
qqnorm(resid(Model1))
qqline(resid(Model1), col="red")
hist(resid(Model1))

Model2 <- lm(AmountSpent~Salary+factor(Gender)+Salary*factor(Gender))
summary(Model2)

plot(resid(Model2)~fitted(Model2))
abline(h=0)
qqnorm(resid(Model2))
qqline(resid(Model2), col="red")
hist(resid(Model2))

logAS<-log(AmountSpent)
Model3 <- lm(logAS~Salary+factor(Gender))
summary(Model3)

plot(resid(Model3)~fitted(Model3))
abline(h=0)
qqnorm(resid(Model3))
qqline(resid(Model3), col="red")
hist(resid(Model3))

logSalary<-log(Salary)
Model4 <- lm(logAS~logSalary+factor(Gender)+logSalary*factor(Gender))
summary(Model4)

plot(resid(Model4)~fitted(Model4))
abline(h=0)
qqnorm(resid(Model4))
qqline(resid(Model4), col="red")
hist(resid(Model4))
