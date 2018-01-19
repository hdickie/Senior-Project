# setup
library(googledrive)
library(RMySQL)
library(reshape2)
library(magrittr)
library(httpuv)

# Connect to Google Drive
sheetID <- "1OptJ6WOldBUdpN0NhTdAuFgDMuBOkkQo"
filename <- drive_get(as_id(sheetID))$name
drive_download(filename, type = "csv", overwrite = TRUE)

# some cleanup
data <- read.csv(filename) #data has each date as a column
melt.data <- melt(data)
names(melt.data) <- c("Page","Date","Pageviews")

# clean up date format
melt.data[,2] <- melt.data[,2] %>% substr(2,nchar(melt.data[,2] %>% as.character()))
melt.data[,2] <- gsub("[^0-9]","/",melt.data[,2])
melt.data[,2] <- as.Date(melt.data[,2],format = "%m/%d/%Y")

# convert to character so uploaded to database correctly
melt.data[,1] <- melt.data[,1] %>% as.character()
melt.data[,2] <- melt.data[,2] %>% as.character()
melt.data[,3] <- melt.data[,3] %>% as.character()

# into Database
database <- dbConnect(MySQL(), user='root', password='MyNewPass', dbname='senior_project', host='localhost')
dbWriteTable(database,name="web_traffic",melt.data,append=TRUE)
