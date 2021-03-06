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

df2 <- subset(df, GEN_ACTIVITY != "LAND_CLEAR")
df3 <- subset(df, SEQ_INT > 0 )

mcDf = data.frame()
#mean.time = data.frame() 
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
  
  # find mean recurrent time for each state for each project
  recurrTime_tmp <- meanRecurrenceTime(mc_tmp)
  
  #create a dataframe for each markov chain
  mc <- as(mc_tmp, "data.frame")
  mc$project <- p
  #mc$mean.recur.time <- recurrTime_tmp
  #mc$mean_time <- mean_ttime
  #combine all the frames together...
  mcDf <- rbind(mcDf, mc)
  #mean.time <- rbind(mean.time, recurrTime_tmp)
  # It worked!
}

# Filter out "DEFAULT FOR NOT REQUIRED" and "CE without DM" from projects, probably better to do this before the loop

mcDf_NEPA <- subset(mcDf, project != "DEFAULT FOR NOT REQUIRED")
mcDf_NEPA <- subset(mcDf_NEPA, project != "CE without DM")

mcDf_NEPA %>% select(mcDf_NEPA, t0, t1, prob)

# test out fitting and simulating markov chains from data
states_test <- unique(df$GEN_ACTIVITY)
seq_test <- createSequenceMatrix(df$GEN_ACTIVITY, toRowProbs = TRUE, sanitize = TRUE)
mctest <- new("markovchain", states = states_test, transitionMatrix = seq_test)

# df with no LAND_CLEAR
states_test2 <- unique(df2$GEN_ACTIVITY)
seq_test2 <- createSequenceMatrix(df2$GEN_ACTIVITY, toRowProbs = TRUE, sanitize = TRUE)
mctest2 <- new("markovchain", states = states_test2, transitionMatrix = seq_test2)

# df with only SEQ_INT >0 days
states_test3 <- unique(df3$GEN_ACTIVITY)
seq_test3 <- createSequenceMatrix(df3$GEN_ACTIVITY, toRowProbs = TRUE, sanitize = TRUE)
mctest3 <- new("markovchain", states = states_test3, transitionMatrix = seq_test3)

seq_sim <- rmarkovchain(5, mctest, "data.frame", t0 = "INT_CUT")
seq_sim

seq_sim2 <- rmarkovchain(5, mctest2, "data.frame", t0 = "INT_CUT")
seq_sim2

seq_sim3 <- rmarkovchain(5, mctest3, "data.frame", t0 = "INT_CUT")
seq_sim3
## could run a for loop of this to generate an ensemble of chains? What about the time between transitions??

## Let's test a for loop fo repeat the sequence simulation 20 times.
## Don't need a for loop, need replicate

seq_sims <- replicate(20, {
  sequence <- rmarkovchain(5, mctest, "data.frame", t0 = "EA-RH-NFH") 
})

seq_sims2 <- replicate(20, {
  sequence <- rmarkovchain(5, mctest2, "data.frame", t0 = "INT_CUT") 
})

seq_sims3 <- replicate(20, {
  sequence <- rmarkovchain(5, mctest3, "data.frame", t0 = "INT_CUT") 
})

## Something strange happening with LAND_CLEAR - maybe once land is cleared doesn't leave that state for a while??


recurrentStates(mctest)
time_list <- meanRecurrenceTime(mctest)
(time_list)
# could add the 2 lines above to for loop?

