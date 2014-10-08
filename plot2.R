# plot2.R

plot2 <- function() {
     
     library("data.table")
     
     hhData = loadData() # function below...
     

     # Open the png file as a device, plot the graph there, and close it...
     png(filename = "plot2.png", width = 480, height = 480, units = "px")
     with(hhData, plot(DateTime, Global_active_power, type = "l", 
                    main = "", xlab = "", 
                    ylab = "Global Active Power (kilowatts)"))
     dev.off()
     
}


# This function should really be factored out into its own source file,
# but copies are included in each Plot*.R file for easier evaluation.
loadData <- function() {
     
     # ASSUMES that working directory is set and data file is present.
     
     # load data file into data.table (not a data.frame) for performance
     fullDT <- suppressWarnings(fread(
          "household_power_consumption.txt", na.strings = "?"))
     
     # coerce the data and time into data.table's formats,
     # adding a consolidated date/time column
     fullDT[,Date := as.IDate(Date, format = "%d/%m/%Y")]
     fullDT[,Time := as.ITime(Time)]
     fullDT[,DateTime := as.POSIXct(Date, Time)]
     
     # subset for the dates we want
     setkey(fullDT, Date)
     targetDT <- subset(fullDT, Date == '2007-02-01' | Date == '2007-02-02')
     
     # coerce numeric columns into appropriate format
     
     targetDT[,Global_active_power := as.numeric(Global_active_power)]
     targetDT[,Global_reactive_power := as.numeric(Global_reactive_power)]
     targetDT[,Voltage := as.numeric(Voltage)]
     targetDT[,Global_intensity := as.numeric(Global_intensity)]
     targetDT[,Sub_metering_1 := as.numeric(Sub_metering_1)]
     targetDT[,Sub_metering_2 := as.numeric(Sub_metering_2)]
     targetDT[,Sub_metering_3 := as.numeric(Sub_metering_3)]
     
     setkey(targetDT, DateTime)
     
     return (targetDT)
     
}
