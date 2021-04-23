library(markovchain)
library(dplyr)
library(tidyverse)

df <- read.csv('proj_newcode2_20210419.csv')
df$ACRES <- as.numeric(df$ACRES)

projects <- unique(df$NEPA_PROJECT)

