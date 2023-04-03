# Airline_data.xlsx
attach(Airline_data)

# Build a simple regression model

slr<-lm(FARE~DISTANCE)
summary(slr)
plot(FARE~DISTANCE)
abline(slr,col="blue")

# Build a multiple regression model
mlr<-lm(FARE~DISTANCE+PAX)
summary(mlr)

# Add Dummy Variable
# Add "SW": SW = YES or NO

# reference = No (default)
Model1<- lm(FARE~DISTANCE+factor(SW))
# or simply Model1<- lm(FARE~DISTANCE+SW
summary(Model1)
    
#reference = Yes
Model1.Yes<- lm(FARE~DISTANCE+relevel(factor(SW),ref="Yes"))
#or Model1<- lm(FARE~DISTANCE+factor(SW,levels=c("Yes","No")))
summary(Model1.Yes)

# plots
plot(FARE~DISTANCE,col=factor(SW))
legend("topleft",legend=levels(factor(SW)), pch = 19, col=factor(levels(factor(SW))))
abline(Model1) 
abline(Model1.Yes)  

# Add "NEW": NEW = 0,1,2,3
Model2<- lm(FARE~DISTANCE+factor(NEW))
summary(Model2)

# Add Interaction term: DISTANCE * SW
Model3<- lm(FARE~DISTANCE+SW+DISTANCE*SW)
summary(Model3)
