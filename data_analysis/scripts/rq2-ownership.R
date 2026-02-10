setwd("/Users/gbavota/Desktop/TSE_MAJOR/")
library(lme4)
library(lmerTest)
library(broom.mixed)
library(dplyr)
library(marginaleffects)
library(knitr)
library(kableExtra)
library(performance)
library(tableone)

rq2_data<-read.csv("rq2_ownership.csv")
attach(rq2_data)

model_ownership <- glmer(
  question_score ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience + All.lines +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    Task_Questions_type +
    Session.order + 
    (1 | Experiment) +
    (1 | Participant_ID),
  data = rq2_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5)) #Convergence issues
)

summary(model_ownership)

#odds ratios with 95% CIs - Printing model table for paper
or_table <- tidy(model_ownership, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)

#average marginal effects (change in probability of question_score = 1 when Treatment = WAI vs NAI)
ame <- avg_slopes(model_ownership)
ame

###########################################################################
###########################################################################

#Stratified analysis per question type
model_ownership_open_questions <- glmer(
  question_score ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience + All.lines +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type + Session.order +
    (1 | Experiment) +
    (1 | Participant_ID),
  data = subset(rq2_data, Task_Questions_type == "open"),
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5)) #Convergence issues
)

summary(model_ownership_open_questions)
or_table <- tidy(model_ownership_open_questions, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)
or_table

model_ownership_closed_questions <- glmer(
  question_score ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience + All.lines +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type + Session.order +
    (1 | Experiment) +
    (1 | Participant_ID),
  data = subset(rq2_data, Task_Questions_type == "closed"),
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5)) #Convergence issues
)

summary(model_ownership_closed_questions)

or_table <- tidy(model_ownership_closed_questions, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)
or_table

###########################################################################
###########################################################################

#Include a Treatment×Period interaction
model_ownership <- glmer(
  question_score ~ Treatment*Session.order +
    Education + Position + year_experience + All.lines +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    Task_Questions_type + 
    (1 | Experiment) +
    (1 | Participant_ID),
  data = rq2_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5)) #Convergence issues
)

summary(model_ownership)

###########################################################################
###########################################################################

#Sensitivity restricted to Period-1 data to rule out carryover

model_ownership <- glmer(
  question_score ~ Treatment +
    Education + Position + year_experience + All.lines +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    Task_Questions_type + 
    (1 | Experiment) +
    (1 | Participant_ID),
  data = subset(rq2_data, Session.order == "First"),
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5)) #Convergence issues
)

summary(model_ownership)

###########################################################################
###########################################################################


#Professionals+researchers sensitivity as an external-validity bound
model_ownership_cohort <- update(
  model_ownership,
  . ~ . + Treatment:Position
)

summary(model_ownership_cohort)
or_table <- tidy(model_ownership_cohort, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)


rq2_professional <- subset(rq2_data, Position != "Bachelor" & Position != "Master")

model_ownership_prof <- update(
  model_ownership,
  data = rq2_professional
)

summary(model_ownership_prof)
or_table <- tidy(model_ownership_prof, effects = "fixed", conf.int = TRUE, exponentiate = TRUE)