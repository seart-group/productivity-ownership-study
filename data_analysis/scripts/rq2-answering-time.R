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

rq2_data<-read.csv("../data/rq2_ownership.csv")
attach(rq2_data)


#RQ2 - Answering time
rq2_data_time<-read.csv("../data/rq1_rq2_times.csv")
attach(rq2_data_time)
model_answer_time <- lmer(
    log(Questions.time..minutes.) ~ relevel(factor(Treatment), ref = "NAI") +
      Education + Position + year_experience +
      Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
      All.lines +
      Session.order +
      offset(log(num_valid_questions)) +
      (1|Experiment) +
      (1 | Participant_ID),
    data = rq2_data_time
)

summary(model_answer_time)

#odds ratios with 95% CIs
table <- tidy(model_answer_time, effects = "fixed", conf.int = TRUE)

#Q-Q plot of residuals
qqnorm(resid(model_answer_time))
qqline(resid(model_answer_time))


###########################################################################
###########################################################################

#Include a Treatment×Period interaction
model_answer_time <- lmer(
  log(Questions.time..minutes.) ~ Treatment*Session.order +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    All.lines +
    offset(log(num_valid_questions)) +
    (1|Experiment) +
    (1 | Participant_ID),
  data = rq2_data_time
)

summary(model_answer_time)

###########################################################################
###########################################################################

#Sensitivity restricted to Period-1 data to rule out carryover

model_answer_time <- lmer(
  log(Questions.time..minutes.) ~ Treatment +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    All.lines +
    offset(log(num_valid_questions)) +
    (1|Experiment),
  data = subset(rq2_data_time, Session.order == "First")
)

summary(model_answer_time)


###########################################################################
###########################################################################

#Compare included vs excluded participants on observable covariates
time_data <- read.csv("compare-participants-no-time-data.csv")
time_data$included <- !is.na(time_data$Implementation.time..minutes.)

glm_inclusion <- glm(
  included ~ Treatment + Education + Position + year_experience + Task_type + Task + Session.order + Language,
  data = time_data,
  family = binomial
)
summary(glm_inclusion)