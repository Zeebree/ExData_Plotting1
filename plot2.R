## Script for creating global active power plot for the dates 2007-02-01 and 2007-02-02
## Prerequires packages: lubridate, dplyr

library(lubridate)
library(dplyr)


## 1. If not, Download dataset Electric power consumption and save it in working environment
if (!file.exists("household_power_consumption.zip")){
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, destfile = "household_power_consumption.zip")
}


## 2. If not, Unzip the file
if (!file.exists("household_power_consumption.txt")){
        unzip(zipfile = "household_power_consumption.zip", 
              file = "household_power_consumption.txt")
}


## 3. Load data only for the dates 2007-02-01 and 2007-02-02 
## and clean it (convert Data and Time values to Data/Time class)
header <- read.csv(file = "household_power_consumption.txt", header = FALSE, 
                   sep = ";", nrows = 1, stringsAsFactors = FALSE)
data <- read.csv(file = "household_power_consumption.txt", header = FALSE, 
                 sep = ";", na.strings = "?", skip = 66637, nrows = 2880, 
                 stringsAsFactors = FALSE)
names(data) <- header
head(data) # Test: Check data from begining of the dates 2007-02-01
tail(data) # Test: Check data from end of the dates 2007-02-02
# Convert to Data/Time class
data$DataTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
plot_data <- data %>% select(-Date, -Time, DataTime, Global_active_power)


## 4. Make plot Global Active Power and save it to png file
png(filename="plot2.png", width = 480, height = 480)
with(plot_data, plot(DataTime, Global_active_power, type="l",
                     xlab = "",
                     ylab = "Global Active Power (kilowatts)"))
dev.off()
