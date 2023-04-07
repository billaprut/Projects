
attach(GoodMorning)

library(corrplot)

library(car)

library(MASS)


# ModelA

ModelA<-lm(`Units Sold`~., data = GoodMorning)
summary(ModelA)

# Plots
plot(resid(ModelA)~fitted(ModelA))
abline(h=0, col="blue")

plot(ModelA)

# Scatter plot fit vs. UnitsSold
plot(`Units Sold`, fitted(ModelA), xlim = c(-100,600), ylim = c(-100, 600))
abline(lm(fitted(ModelA)~`Units Sold`), col ="red")
abline(h=0, col="blue")
abline(v=0, col="blue")

# Histogram 
hist(resid(ModelA))

# Compute VIF
vif(ModelA)


# ModelB

#Backward elimination
StepBW<-step(ModelA,direction = "backward")
summary(StepBW)
adjr2.StepBW<-summary(StepBW)$adj.r.squared
vif(StepBW)


#Foward selection
StepFW<-step(ModelA,direction = "forward")
summary(StepFW)
adjr2.StepFW<-summary(StepFW)$adj.r.squared
vif(StepFW)

#Stepwise
StepW<-step(ModelA,direction = "both")
summary(StepW)
adjr2.StepW<-summary(StepW)$adj.r.squared
vif(StepW)

AIC(StepBW, StepFW, StepW)
BIC(StepBW, StepFW, StepW)
print(c(adjr2.StepBW, adjr2.StepFW, adjr2.StepW))

# Remove columns
dt<-(GoodMorning[,c(-1,-9,-10)])

ModelB<-lm(`Units Sold`~., data = dt)
summary(ModelB)

# Plots
plot(resid(ModelB)~fitted(ModelB))
abline(h=0, col="blue")

plot(ModelB)

# Scatter plot fit vs. UnitsSold
plot(`Units Sold`, fitted(ModelB), xlim = c(-100,600), ylim = c(-100, 600))
abline(lm(fitted(ModelB)~`Units Sold`), col ="red")
abline(h=0, col="blue")
abline(v=0, col="blue")

# Histogram 
hist(resid(ModelB))

# Compute VIF
vif(ModelB)

