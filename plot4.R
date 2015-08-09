##checks to see if file is downloaded; if it is continues, otherwise downloads file
if(!file.exists("household_power_consumption.txt")){
       tempdata<-tempfile()
       download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tempdata)
       powerdata<-unzip(tempdata)
       unlink(tempdata)
}else{
       powerdata<-data.table::fread("household_power_consumption.txt", na.strings="?")
       powerdata$Sub_metering_1 <- as.numeric(as.character(powerdata$Sub_metering_1))
       powerdata$Sub_metering_2 <- as.numeric(as.character(powerdata$Sub_metering_2))
       powerdata$Sub_metering_3 <- as.numeric(as.character(powerdata$Sub_metering_3))
}

##converts date using as.Date
powerdata$Date <- as.Date(powerdata$Date, format="%d/%m/%Y")

##focuses only on 1/2/2007 and 2/2/2007
epc<-powerdata[(powerdata$Date=="2007-02-01" | powerdata$Date=="2007-02-02")]

##creates new table
epc <-transform(epc, datetime=as.POSIXct(paste(Date, Time)), "%d%m%Y %H:%M:%S" )

##creates 4 plots
par(mfcol=c(2,2))
##plot1
plot(epc$datetime, epc$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")

##creates plot 3: linegraph with colors 
plot(epc$datetime,epc$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(epc$datetime,epc$Sub_metering_2,col="red")
lines(epc$datetime,epc$Sub_metering_3,col="blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))

##plot2
plot(epc$datetime, epc$Voltage, type="l", xlab="datetime", ylab="Voltage")


##plot4
plot(epc$datetime, epc$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")


##creates png file
dev.copy(png, file="plot4.png")
dev.off()
