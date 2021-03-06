library(graphics)
library(ggplot2)
library(tidyverse)
library(knitr)
library(gridExtra)
library(Rmisc)
library(ggpubr)
library(GGally)

setwd("C:/Users/Daivik/Desktop/EDA/Final Project")
data <- read.csv("HeartAbridged.csv")

# Graphing Distributions of Variables

hist(data$RestBP)
d_RestBP <- density(data$RestBP)
plot(d_RestBP, main="Kernel Density of Rest BP")
polygon(d_RestBP, col="green", border="blue")

hist(data$Age)
d_Age <- density(data$Age)
plot(d_Age, main="Kernel Density of Age")
polygon(d_Age, col="green", border="blue")

hist(data$Chol)
d_Chol <- density(data$Chol)
plot(d_Chol, main="Kernel Density of Chol")
polygon(d_Chol, col="green", border="blue")

hist(data$MaxHR)
d_MaxHR <- density(data$MaxHR)
plot(d_MaxHR, main="Kernel Density of MaxHR")
polygon(d_MaxHR, col="green", border="blue")

# Graphing Distributions of Variables grouped by AHD

RestBP <- ggplot(data, aes(x=RestBP, color = AHD, fill = AHD)) + geom_density(alpha=0.6)
RestBP

Age <- ggplot(data, aes(x=Age, color = AHD, fill = AHD)) + geom_density(alpha=0.6)
Age

MaxHR <- ggplot(data, aes(x=MaxHR, color = AHD, fill = AHD)) + geom_density(alpha=0.6)
MaxHR

Chol <- ggplot(data, aes(x=Chol, color = AHD, fill = AHD)) + geom_density(alpha=0.6)
Chol

# 99% confidence for the difference in the means of those with heart disease and those without heart disease

Heart <- filter(data, AHD=='Yes')
No_Heart <- filter(data, AHD=='No')

y1 <- Heart$RestBP
ybar1 <- mean(y1); s1 <- sd(y1); n1 <- length(y1)

y2 <- No_Heart$RestBP
ybar2 <- mean(y2); s2 <- sd(y2); n2 <- length(y2)

spsq <- ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2)
sp <- sqrt(spsq)

df.pooled <- n1+n2-2
(ybar1 - ybar2) +c(-1,1)*qt(.995, df.pooled)*sp*sqrt(1/n1+1/n2)

Heart <- filter(data, AHD=='Yes')
No_Heart <- filter(data, AHD=='No')

y1 <- Heart$Age
ybar1 <- mean(y1); s1 <- sd(y1); n1 <- length(y1)

y2 <- No_Heart$Age
ybar2 <- mean(y2); s2 <- sd(y2); n2 <- length(y2)

spsq <- ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2)
sp <- sqrt(spsq)

df.pooled <- n1+n2-2
(ybar1 - ybar2) +c(-1,1)*qt(.995, df.pooled)*sp*sqrt(1/n1+1/n2)

Heart <- filter(data, AHD=='Yes')
No_Heart <- filter(data, AHD=='No')

y1 <- No_Heart$MaxHR
ybar1 <- mean(y1); s1 <- sd(y1); n1 <- length(y1)

y2 <- Heart$MaxHR
ybar2 <- mean(y2); s2 <- sd(y2); n2 <- length(y2)

spsq <- ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2)
sp <- sqrt(spsq)

df.pooled <- n1+n2-2
(ybar1 - ybar2) +c(-1,1)*qt(.995, df.pooled)*sp*sqrt(1/n1+1/n2)

Heart <- filter(data, AHD=='Yes')
No_Heart <- filter(data, AHD=='No')

y1 <- Heart$Chol
ybar1 <- mean(y1); s1 <- sd(y1); n1 <- length(y1)

y2 <- No_Heart$Chol
ybar2 <- mean(y2); s2 <- sd(y2); n2 <- length(y2)

spsq <- ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2)
sp <- sqrt(spsq)

df.pooled <- n1+n2-2
(ybar1 - ybar2) +c(-1,1)*qt(.995, df.pooled)*sp*sqrt(1/n1+1/n2)

# Hypothesis test for each variable to see if the mean of those with heart disease differs from the mean of those without heart disease

t.test(RestBP~AHD, data=data)
t.test(Age~AHD, data=data)
t.test(MaxHR~AHD, data=data)
t.test(Chol~AHD, data=data)

# Pairwise Scatter Plots for all variables

ggplot(data, aes(x = Age, y = RestBP)) + geom_point()
cor(data$Age, data$RestBP)
ggplot(data, aes(x = Age, y = Chol)) + geom_point()
cor(data$Age, data$Chol)
ggplot(data, aes(x = Age, y = MaxHR)) + geom_point()
cor(data$Age, data$MaxHR)
ggplot(data, aes(x = RestBP, y = Chol)) + geom_point()
cor(data$RestBP, data$Chol)
ggplot(data, aes(x = RestBP, y = MaxHR)) + geom_point()
cor(data$RestBP, data$MaxHR)
ggplot(data, aes(x = Chol, y = MaxHR)) + geom_point()
cor(data$Chol, data$MaxHR)

ggplot(data, aes(x = Age, y = MaxHR)) + geom_point() +
  geom_smooth(method = "lm", se = F, col = "red") +
  stat_cor()

ggpairs(data)

summary(data)

# Creating a scatterplot of the data with the regression line on it

scatter.smooth(x=data$Age, y=data$MaxHR, main="MaxHR ~ Age") 

# Creating the linear regression model between the two variables

data.lm <- lm(data$MaxHR~data$Age, data) 
summary(data.lm)
ggplot(data, aes(x = Age, y = MaxHR)) + geom_point() + geom_smooth(method = "lm", se = FALSE)

# Performing a hypothesis test to assess whether the predictor variable is a "good" predictor in a linear model

x <- predict(data.lm, data.frame(Age=1:303))
summary(x)

# Confidence Interval for slope

confint(data.lm, level = 0.99)

# Providing predictions of the value of the response variable at the 20th, 40th, 60th, and 80th, percentiles of the predictor variable

ages = data$Age     
quantile(ages, c(.20, .40, .60, .80)) 
y <- predict(data.lm, data.frame(45, 53, 58, 62), interval='confidence')
summary(y)

# Checking Regression Assumptions

data$residuals <- residuals(data.lm)
ggplot(data, aes(sample = residuals)) + stat_qq() + stat_qq_line()

data$fitted <- fitted(data.lm)
data$residuals <- residuals(data.lm)
sum(data$residuals - (data$MaxHR - data$fitted))

plot(data.lm, 1) 

plot(data.lm, 3)
plot(data.lm)

# Logistic Regression Model

mylogit <- glm(data$AHD ~ data$RestBP + data$Age + data$Chol + data$MaxHR, data = data, family = "binomial")
summary(mylogit)

anova(mylogit, test="Chisq")

fitted.results <- predict(mylogit,newdata=data,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != data$AHD)
print(paste('Accuracy',(1-misClasificError))