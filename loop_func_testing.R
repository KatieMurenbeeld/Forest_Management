library(markovchain)
library(dplyr)
library(tidyverse)

df <- read.csv('proj_newcode2_20210419.csv')
df$ACRES <- as.numeric(df$ACRES)

# remove DEFAULT FOR NOT REQUIRED

#df <- df %>% filter(NEPA_PROJECT != "DEFAULT FOR NOT REQUIRED")

projects <- unique(unlist(df$NEPA_PROJECT))

proj1 <- subset(df, NEPA_PROJECT == projects[1])
print(proj1)


mcDf =data.frame()
for (i in 1:length(projects)) {
  #save project name to variable p
  p <- projects[i]
  
  #create a temporary dataframe for each project
  tmp_df <- subset(df, NEPA_PROJECT == projects[i])
  
  # save mean sequence days for each transition to variable mean_ttime
  # may not be needed
  #mean_ttime <- mean(tmp_df$SEQ_INT)
  
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
  mc$project <- p
  #mc$mean_time <- mean_ttime
  #combine all the frames together...
  mcDf <- rbind(mcDf, mc)
  # It worked!
}

# Filter out "DEFAULT FOR NOT REQUIRED" and "CE without DM" from projects, probably better to do this before the loop

mcDf_NEPA <- subset(mcDf, project != "DEFAULT FOR NOT REQUIRED")
mcDf_NEPA <- subset(mcDf_NEPA, project != "CE without DM")
