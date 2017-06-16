## Script for creating energy sub metering plot for the dates 2007-02-01 and 2007-02-02
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
plot_data <- data %>% select(-Date, -Time)


## 4. Make plots energy for energy power consumption and save it to png file
png(filename="plot4.png", width = 480, height = 480)
par(mfcol=c(2,2))
## Global Active Power plot
with(plot_data, plot(DataTime, Global_active_power, type="l",
                     xlab = "",
                     ylab = "Global Active Power (kilowatts)"))
## Energy sub metering plot
with(plot_data, plot(DataTime, Sub_metering_1, type="l", col = "black",
                     xlab = "",
                     ylab = "Energy sub metering "))
with(plot_data, lines(DataTime, Sub_metering_2, type="l", col = "red"))
with(plot_data, lines(DataTime, Sub_metering_3, type="l", col = "blue"))
legend("topright", col = c("black", "red", "blue"), lty=1, bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_2"))
## Voltage plot
with(plot_data, plot(DataTime, Voltage, type="l", 
                     xlab="datatime", ylab = "Voltage"))
## Global_reactive_power plot
with(plot_data, plot(DataTime, Global_reactive_power, type="l",
                     xlab="datatime", ylab = "Global_reactive_power"))
dev.off()
