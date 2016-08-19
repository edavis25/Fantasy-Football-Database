# File: RBVizualizations.R
# Description: Summarizes historical data on given rb's
# Date: 18 August 2016
# Author: Mark Eidsaune

library('tidyr')
library('plyr')
library('dplyr')
library('ggplot2')
library('lubridate')

rb_hist <- read.csv("./rb_14-16.csv", header = TRUE)
## Turns Date column into date objects
rb_hist$Date <- ymd(rb_hist$Date)

## For selecting a custom list of rbs
names <- c('Adrian Peterson')
ap <- filter(rb_hist, Name %in% names)

## Top 20 average PPR pts
## Group by Name, summarize by mean PPR
rb_avgpts <- ddply(rb_hist, "Name", summarise, avgPPR = mean(PPR))

## Add new avg PPR rank column
rb_avgpts$PPRrank <- rank(-rb_avgpts$avgPPR)

## select desired columns (might not need this step)
ppr_rank <- select(rb_avgpts, Name, PPRrank)

## join PPRrank column with original d.f.
rb_hist <- left_join(rb_hist, ppr_rank, by = "Name")
## filter desired players 
rb_ppr_rank <- rb_hist %>% filter(PPRrank <= 20)

## Plot point boxplots for top 20 rb based on avg points
plot1 <- ggplot(rb_ppr_rank, aes(x = reorder(Name, PPRrank), y =  PPR)) +
    geom_boxplot()
ggsave("rb_top20_avgpts.png", width = 15, height = 9)

## Boxplot of rb points under each scoring system
rb_gathered <- rb_hist %>% gather(scoring_system, points, FanDuel:PPR)
rb_gathered_top20 <- filter(rb_gathered, PPRrank <= 20)

plot2 <- ggplot(rb_gathered_top20, aes(x = reorder(Name, PPRrank), y = points, fill = scoring_system)) +
    geom_boxplot()
ggsave("rb_points_hist.png", width = 15, height = 9)

## Boxplot of difference in ppr and standard scoring
rb_diff <- mutate(rb_hist, scoring_diff = PPR - Standard)

## Group by Name, summarize by avg scoring difference (NOT USED)
rb_avgdiff <- ddply(rb_diff, "Name", summarise, avg_diff = mean(scoring_diff))

rb_diff <- filter(rb_diff, PPRrank <= 20)

## 
plot3 <- ggplot(rb_diff, aes(x = reorder(Name, PPRrank), y = scoring_diff)) +
    geom_boxplot()
ggsave("ppr_boost.png", width = 15, height = 9)








