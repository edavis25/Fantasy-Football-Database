# File: team_plots.R
# Description: Game plots
# Date: 30 December 2016
# Author: Mark Eidsaune

library(dplyr)
library(reshape2)
library(ggplot2)

teamgame <- read.csv("team_game.csv")

teamgame$Date <- as.Date(teamgame$Date)

# All Teams
## plot1 = display each team's average difference in pts scored v. opponent's pts scored for all historical data
ptdiff <- teamgame %>% mutate(diff = TotalScore-OppScore) %>%
    group_by(Name) %>% summarise(avgdiff = mean(diff))

plot1 <- ggplot(ptdiff, aes(reorder(Name, avgdiff), avgdiff)) +
    geom_bar(stat = "identity") +
    coord_flip()
ggsave("Avgdiff.png")

## plot2 = each team's win-loss ratio w/ color = average pt difference (same as plot1)
team <- teamgame %>% group_by(Name) %>% summarise(wins = length(which(Won == "Y")),
                                                  losses = length(which(Won == "N")),
                                                  avgdiff = mean(TotalScore-OppScore))

plot2 <- ggplot(team, aes(losses, wins, label = Name)) +
    geom_text(aes(color = avgdiff), check_overlap = TRUE) +
    scale_color_gradient()
ggsave("WL.png")

## plot3 = scatterplot of score v. 1st downs (color = Won/Lost)
plot3 <- ggplot(teamgame, aes(X1stDowns, TotalScore, color = Won)) +
    geom_point(alpha = 1/5) +
    labs(x = "1st Downs", y = "Points") +
    scale_alpha(guide = "none") +
    theme(legend.title = element_blank()) +
    scale_color_discrete(breaks = c("Y", "N"),
                         labels = c("Won", "Lost")) +
    scale_shape_discrete(breaks = c("Y", "N"),
                         labels = c("Won", "Lost"))
ggsave("fd_pts.png")

# Individual Teams (49ers shown)
## Time-series (2015 season) of pts scored and opponent pts scored
ninersPts <- teamgame %>% 
    filter(Name == "49ers" & 
               Date > "2014-06-01" & 
               Date < "2015-06-01") %>% 
    select(Date, TotalScore, OppScore)

ninersPts <- melt(ninersPts, id = "Date")

plot4 <- ggplot(ninersPts, aes(Date, value, color = variable, shape = variable)) +
    geom_point() +
    geom_line() +
    geom_vline(aes(xintercept = as.numeric(ninersPts$Date)), color = "grey", linetype = 3) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.ticks = element_blank(),
          legend.title = element_blank()) +
    scale_color_discrete(breaks = c("TotalScore", "OppScore"),
                         labels = c("Team's Score", "Opponent's Score")) +
    scale_shape_discrete(breaks = c("TotalScore", "OppScore"),
                         labels = c("Team's Score", "Opponent's Score"))
ggsave("Pts.png")

## Times-series (2015 season) of passing and rushing yds
ninersYds <- teamgame %>%
    filter(Name == "49ers" &
               Date > "2014-06-01" &
               Date < "2015-06-01") %>%
    select(Date, RushYds, PassYds)

ninersYds <- melt(ninersYds, id = "Date")

plot5 <- ggplot(ninersYds, aes(Date, value, color = variable, shape = variable)) +
    geom_point() +
    geom_line() +
    geom_vline(aes(xintercept = as.numeric(ninersYds$Date)), color = "grey", linetype = 3) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.ticks = element_blank(),
          legend.title = element_blank()) +
    scale_color_discrete(breaks = c("RushYds", "PassYds"),
                         labels = c("Rush Yards", "Pass Yards")) +
    scale_shape_discrete(breaks = c("RushYds", "PassYds"),
                         labels = c("Rush Yards", "Pass Yards"))
ggsave("Yds.png")

## Alternative pts plot shows one line representing each game's difference in pts and opponents pts.   
ninersPts2 <- teamgame %>% 
    filter(Name == "49ers" & 
               Date > "2014-06-01" & 
               Date < "2015-06-01") %>% 
    select(Date, TotalScore, OppScore, Won) %>% 
    mutate(diff = TotalScore - OppScore)

plot6 <- ggplot(ninersPts2, aes(Date, diff)) +
    geom_point(aes(color = Won)) +
    geom_line(linetype = 4) +
    geom_vline(aes(xintercept = as.numeric(ninersPts2$Date)), color = "grey", linetype = 3) +
    geom_hline(aes(yintercept = 0)) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.ticks = element_blank(),
          legend.title = element_blank()) +
    scale_color_discrete(breaks = c("Y", "N"),
                         labels = c("Won", "Lost"))
ggsave("Pts2.png")

## team season pass yards histogram with individual team's pass yards indicated by vertical line
totalPassYds <- teamgame %>% filter(Date > "2014-06-01" & Date < "2015-06-01") %>% 
    group_by(Name) %>% summarise(passYds = sum(PassYds))

plot7 <- ggplot(totalPassYds, aes(passYds)) +
    geom_histogram(binwidth = 500) +
    geom_vline(xintercept = totalPassYds$passYds[totalPassYds$Name == "Patriots"],
               color = "green")
ggsave("passHist.png")
