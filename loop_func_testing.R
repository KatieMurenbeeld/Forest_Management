library(markovchain)
library(dplyr)
library(tidyverse)

df <- read.csv('proj_newcode2_20210419.csv')
df$ACRES <- as.numeric(df$ACRES)

projects <- unique(unlist(df$NEPA_PROJECT))

proj1 <- subset(df, NEPA_PROJECT == projects[1])
print(proj1)


rows = c()
cols = c()
y = c()
legend = c()
for (i in 1:length(projects)) {
  p <- projects[i]
  #create a temporary dataframe for each project
  test_df <- subset(df, NEPA_PROJECT == projects[i])
  #create a sequence matrix for each project
  seq_test <- createSequenceMatrix(test_df$GEN_ACTIVITY, toRowProbs = TRUE, sanitize = TRUE)
  r <- rownames(seq_test)
  c <- colnames(seq_test)
  test <- combine(r,c)
  y <- append(y, seq_test)
  rows <- append(rows, r)
  cols <- append(cols, c)
  legend <- append(legend, test)
  #return(y)
}

print(projects[1])
proj1_seq <- createSequenceMatrix(proj1$GEN_ACTIVITY, toRowProbs = TRUE, sanitize=TRUE)
proj1_seq

length(y)
length(rows)
length(cols)

test <- merge(y, )