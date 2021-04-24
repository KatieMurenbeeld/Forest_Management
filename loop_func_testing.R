library(markovchain)
library(dplyr)
library(tidyverse)

df <- read.csv('proj_newcode2_20210419.csv')
df$ACRES <- as.numeric(df$ACRES)

projects <- unique(unlist(df$NEPA_PROJECT))

proj1 <- subset(df, NEPA_PROJECT == projects[1])
print(proj1)


mcDf =data.frame()
for (i in 1:length(projects)) {
  p <- projects[i]
  #create a temporary dataframe for each project
  tmp_df <- subset(df, NEPA_PROJECT == projects[i])
  #create a sequence matrix for each project
  seq_tmp <- createSequenceMatrix(tmp_df$GEN_ACTIVITY, toRowProbs = TRUE, sanitize = TRUE)
  #create a vector of states for each project
  states_tmp <- unique(tmp_df$GEN_ACTIVITY)
  #create a markov chain for each project
  mc_tmp <- new("markovchain", 
                states = states_tmp,
                transitionMatrix = seq_tmp)
  #create a dataframe for each markov chain
  mc <- as(mc_tmp, "data.frame")
  #combine all the frames together...
  mcDf <- rbind(mcDf, p, mc)
  # It worked!
}
