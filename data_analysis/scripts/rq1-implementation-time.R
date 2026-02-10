setwd("./")
library(lme4)
library(lmerTest)
library(broom.mixed)
library(dplyr)
library(marginaleffects)
library(knitr)
library(kableExtra)
library(performance)
library(tableone)

#RQ1 - Implementation time
rq1_data_time<-read.csv("../data/rq1_rq2_times.csv")
attach(rq1_data_time)
model_impl_time <- lmer(
  log(Implementation.time..minutes.) ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    All.lines +
    Session.order +
    (1|Experiment) +
    (1 | Participant_ID),
  data = rq1_data_time
)

summary(model_impl_time)

#odds ratios with 95% CIs
table <- tidy(model_impl_time, effects = "fixed", conf.int = TRUE)

#Q-Q plot of residuals
qqnorm(resid(model_impl_time))
qqline(resid(model_impl_time))


###########################################################################
###########################################################################

#Include a Treatment×Period interaction

model_impl_time <- lmer(
  log(Implementation.time..minutes.) ~ Treatment*Session.order +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    All.lines +
    (1|Experiment) +
    (1 | Participant_ID),
  data = rq1_data_time
)

summary(model_impl_time)

###########################################################################
###########################################################################

#Sensitivity restricted to Period-1 data to rule out carryover

model_impl_time <- lmer(
  log(Implementation.time..minutes.) ~ Treatment +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    All.lines +
    (1|Experiment),
    data = subset(rq1_data_time, Session.order == "First")
)

summary(model_impl_time)


###########################################################################
###########################################################################

#Compare included vs excluded participants on observable covariates
time_data <- read.csv("../data/compare-participants-no-time-data.csv")
time_data$included <- !is.na(time_data$Implementation.time..minutes.)

glm_inclusion <- glm(
  included ~ Treatment + Education + Position + year_experience + Task_type + Task + Session.order + Language,
  data = time_data,
  family = binomial
)
summary(glm_inclusion)