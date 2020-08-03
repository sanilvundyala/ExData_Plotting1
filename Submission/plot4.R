plot4 <- function(){
  #Initialize script dependant package
  library(dplyr)
  
  #Download relevant data zip file and unpacks contained txt file if not already done
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  zip <- "power_consumption_data.zip"
  tablepath <- "household_power_consumption.txt"
  if(!file.exists(zip)){
    download.file(url, zip)
  }
  if(!file.exists(tablepath)){
    unzip(zip)
  }
  
  #Read only data from Feb 1-2 2007, into dataframe, with given variable names from dataset.
  data <- read.table(tablepath, sep = ";", na.strings = c("?",""), skip = 66637,
                     nrows = 2880, col.names = c("Date","Time","Global_active_power",
                                                 "Global_reactive_power","Voltage","Global_intensity",
                                                 "Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                     colClasses = c("character", "character", "numeric","numeric", "numeric","numeric",
                                    "numeric","numeric","numeric"))
  
  # Convert Date and Time columns to POSIXlt from character values. Replaces Data and Time
  # columns with one Date_Time column.
  data <- data %>% 
    mutate(Date_Time = strptime(paste(data$Date, data$Time),format = "%d/%m/%Y %H:%M:%S", tz = "CET"),
           Date = NULL, Time = NULL)
  
  #Open png device and creates plot1.png in working directory
  png(filename = "plot4.png")
  
  #Creates plot 4 as shown in assignment instructions
  par(mfcol = c(2,2))
  
  plot(data$Date_Time, data$Global_active_power, ylab = "Global Active Power (kilowatts)", xlab = "", type = "l")
  
  plot(data$Date_Time, data$Sub_metering_1, ylab = "Energy sub metering", xlab = "", type = "l", col = "Dark Green")
  lines(data$Date_Time,data$Sub_metering_2,col="Red")
  lines(data$Date_Time,data$Sub_metering_3,col="Blue")
  legend("topright", c(names(data)[5:7]), col = c("Dark Green", "Red", "Blue"), lty = 1)
  
  with(data, plot(Date_Time, Voltage, type = "l"))
  
  with(data, plot(Date_Time,Global_reactive_power, type = "l"))
  
  #close device
  dev.off()
  
  
}