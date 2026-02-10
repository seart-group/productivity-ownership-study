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

rq1_data<-read.csv("../data/rq1_completeness.csv")
attach(rq1_data)

model_completeness <- lmer(
  Completeness ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience + 
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task.type + Session.order +
    (1|Experiment) +
    (1|Participant_ID),
  data = rq1_data
)

summary(model_completeness)
#Estimates with 95% CIs
table <- tidy(model_completeness, effects = "fixed", conf.int = TRUE)

###########################################################################
###########################################################################

#Include a Treatment×Period interaction
model_completeness <- lmer(
  Completeness ~ Treatment*Session.order +
    Education + Position + year_experience  +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task.type +
    (1|Experiment) +
    (1|Participant_ID),
  data = rq1_data
)

summary(model_completeness)

###########################################################################
###########################################################################

#Sensitivity restricted to Period-1 data to rule out carryover

model_completeness <- lmer(
  Completeness ~ Treatment +
    Education + Position + year_experience + 
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task.type + 
    (1|Experiment),
  data = subset(rq1_data, Session.order == "First")
)

summary(model_completeness)

###########################################################################
###########################################################################


#Professionals+researchers sensitivity as an external-validity bound
model_completeness_cohort <- update(
  model_completeness,
  . ~ . + Treatment:Position
)

summary(model_completeness_cohort)
or_table <- tidy(model_completeness_cohort, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)


rq1_professional <- subset(rq1_data, Position != "Bachelor" & Position != "Master")

model_completeness_prof <- update(
  model_completeness,
  data = rq1_professional
)

summary(model_completeness_prof)
or_table <- tidy(model_completeness_prof, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)
or_table