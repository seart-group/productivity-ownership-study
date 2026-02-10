This is the replication package of the work **"More Code, Less Understanding? On the Impact of AI Assistants on Developers' Productivity and Code Ownership"**

## Content
- [`data_analysis`](productivity-ownership-study/data_analysi) folder contains
  - the subfolder [`data_analysis/data`](productivity-ownership-study/data_analysis/data) comprising the files with the raw data of the experiments for each research question (RQ) (`rq1_completeness.csv`, `rq1_rq2_times.csv`, `rq2_ownership.csv`, `compare-participants-no-time-data.csv`). It also contains the file `questions_difficulty.csv` which includes the manual analysis of the difficulty of a sample of 100 questions independently performed by two authors. Also, the file `compare-participants-no-time-data.csv` reports data about participants included and excluded in the time-based analyses, which can be used to verify that the exclusions did not bias our results (code for this present in the two R script concerning time-based analyses).
  - the subfolder [`data_analysis/scripts`](productivity-ownership-study/data_analysis/scripts) including scripts used for the statistical analyses (`rq1-completeness.R`, `rq1-implementation-time.R`, `rq2-answering-time.R`, `rq2-ownership.R`). 

- `server_setup` folder contains everything you need to set up the server to replicate the experiments. Please refer to the dedicated `README.md` file within the same folder for further information and instructions.

- `tasks` forlder contains the tasks defined for the experiments.

- `additional_results` folder contains results not shown in the paper due to space constraints. These include: (i) The Q–Q plots of residuals from the log-normal mixed-effects models used in the time-based analyses (`qqplot-implementation-time.pdf` and `qqplot-time-to-answer.pdf`); (ii) Boxplots showing raw and normalized distributions of didChangeTextEditorUI events for both treatments (`didChangeTextEditorUI_events_distribution.pdf`); and (iii) Distribution of valid questions per task and per cohort (`valid_questions_distribution.pdf`).
