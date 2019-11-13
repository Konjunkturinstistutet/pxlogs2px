#' Creates a PX-file from a set of API log files.
#' 
#' This only does stats-logs right now
#' Generate a csv, still to do is to make that csv into a px file.
#' Put the log files in the folder c:\logs\stats
#' The resulting csv is put in c:\logs

library(readr)
library(stringr)
library(plyr)
library(data.table)

filenames = dir(path="C:/logs/stats/",full.names = TRUE)
stats <- data.frame (Time=character(),
                     Context=character(),
                     UserID=character(),
                     Language=character(),
                     Database=character(),
                     ActionType=character(),
                     ActionName=character(),
                     TableID=character(),
                     NumberOfCells=character(),
                     NumberOfContents=character())


for (i in 1:length(filenames)) {
  print(filenames[i])
  statsapp <- read_csv(filenames[i], col_names = FALSE,cols(X1 = col_datetime(format = ""),  X2 = col_character(),  X3 = col_character(),  X4 = col_character(),  X5 = col_character(),  X6 = col_character(),  X7 = col_character(),  X8 = col_character(),  X9 = col_character(),  X10 = col_character())) 
  print("Colnames")  
  colnames(statsapp)<- c("Time","Context","UserID","Language","Database","ActionType","ActionName", "TableID", "NumberOfCells", "NumberOfContents")
  print("rbind")
  stats <- rbind(stats,statsapp)  
}
stats[,"Year"] <- str_sub(as.matrix(stats[,"Time"]),1,4)
stats[,"Month"] <- str_sub(as.matrix(stats[,"Time"]),6,7)
stats[,"Context"] <- gsub(".*=","",as.matrix(stats[,"Context"]))
stats[,"UserID"] <- gsub(".*=","",as.matrix(stats[,"UserID"]))
stats[,"Language"] <- gsub(".*=","",as.matrix(stats[,"Language"]))
stats[,"Database"] <- gsub(".*=","",as.matrix(stats[,"Database"]))
stats[,"ActionType"] <- gsub(".*=","",as.matrix(stats[,"ActionType"]))
stats[,"ActionName"] <- gsub(".*=","",as.matrix(stats[,"ActionName"]))
stats[,"TableID"] <- gsub(".*=","",as.matrix(stats[,"TableID"]))
stats[,"NumberOfCells"] <- gsub(".*=","",as.matrix(stats[,"NumberOfCells"]))

stats[,"Table1"] <- gsub(".*[\\]","A/",as.matrix(stats[,"TableID"]))
stats[,"Table"] <- gsub(".*/","",as.matrix(stats[,"Table1"]))

statsoutput <- count(stats,c('Database','Table','Language','Year','Month','ActionType','ActionName','Context'))

write_csv(statsoutput,"C:/logs/statsoutput.csv",na="NA", append = FALSE, col_names = TRUE)

