setwd("/set/wd/")
library(lme4)
library(lmerTest)
#####################################################
# RQ1: To what extent does AI-based support impact the
# productivity of developers during coding tasks? 
#####################################################
rq1_data<-read.csv("rq1_completeness.csv")
attach(rq1_data)

model_completeness <- lmer(
  Completeness ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task.type +
    (1|Experiment),
  data = rq1_data
)

summary(model_completeness)

rq1_data_time<-read.csv("rq1_rq2_times.csv")
attach(rq1_data_time)
model_impl_time <- lmer(
  Implementation.time..minutes. ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    (1|Experiment),
  data = rq1_data_time
)

summary(model_impl_time)


#####################################################
# RQ2: To what extent does the availability of AI-based 
# support during code writing impact the developer’s 
# code ownership? 
#####################################################
rq2_data<-read.csv("rq2_ownership.csv")
attach(rq2_data)

model_ownership <- lmer(
  question_score ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    (1|Experiment),
  data = rq2_data
)
  
summary(model_ownership)


rq2_data_time<-read.csv("rq1_rq2_times.csv")
attach(rq2_data_time)
model_answer_time <- lmer(
  Questions.time..minutes. ~ relevel(factor(Treatment), ref = "NAI") +
    Education + Position + year_experience +
    Task_D1 + Task_D2 + Task_E2 + Task_D3 + Task_E3 + Task_D4 + Task_type +
    (1|Experiment),
  data = rq2_data_time
)
  
summary(model_answer_time)