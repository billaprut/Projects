# Data: Catalog Marketing_Reg.xlsx
#Loading required R packages

# corrplot, for correlation plot
install.packages("corrplot")
library(corrplot)

#car, for computing vif
install.packages("car")
library(car)

#MASS, for computing stepwise regression
install.packages("MASS")
library(MASS)


# Build linear regression models

#Remove Person and LogAmountSpent
dt<-(Catalog_Marketing_Reg[,c(-1,-11)])

## ModelAll
# Create a model with all variables
ModelAll<-lm(AmountSpent~.,data=dt)
summary(ModelAll)
# Compute VIF
vif(ModelAll)

#Error in vif.default(model) : there are aliased coefficients in the model
#This error typically occurs when multicollinearity exists in a regression model.

# select numeric variables & calculate the correlations
r <- cor(dt[sapply(dt,is.numeric)])
# rounded to 2 decimals
r<-round(r,2)
print(r)
#create a correlation plot
corrplot(r)

#Backward elimination
StepBW<-step(ModelAll,direction = "backward")
summary(StepBW)
adjr2.StepBW<-summary(StepBW)$adj.r.squared
vif(StepBW)


#Foward selection
StepFW<-step(ModelAll,direction = "forward")
summary(StepFW)
adjr2.StepFW<-summary(StepFW)$adj.r.squared
vif(StepFW)

#Stepwise
StepW<-step(ModelAll,direction = "both")
summary(StepW)
adjr2.StepW<-summary(StepW)$adj.r.squared
vif(StepW)

AIC(StepBW, StepFW, StepW)
BIC(StepBW, StepFW, StepW)
print(c(adjr2.StepBW, adjr2.StepFW, adjr2.StepW))

# Bulid exponential models
hist(AmountSpent)
hist(LogAmountSpent)

#Remove Person and AmountSpent
dt2<-(Catalog_Marketing_Reg[,c(-1,-10)])

LogModelAll<-lm(LogAmountSpent~., data=dt2)
summary(LogModelAll)

#Backward elimination
LogStepBW<-step(LogModelAll,direction = "backward")
summary(LogStepBW)
adjr2.LogStepBW<-summary(LogStepBW)$adj.r.squared
vif(LogStepBW)


#Foward selection
LogStepFW<-step(LogModelAll,direction = "forward")
summary(LogStepFW)
adjr2.LogStepFW<-summary(LogStepFW)$adj.r.squared
vif(LogStepFW)

#Stepwise
LogStepW<-step(LogModelAll,direction = "both")
summary(LogStepW)
adjr2.LogStepW<-summary(LogStepW)$adj.r.squared
vif(LogStepW)

AIC(LogStepBW, LogStepFW, LogStepW)
BIC(LogStepBW, LogStepFW, LogStepW)






