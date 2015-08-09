##checks to see if file is downloaded; if it is continues, otherwise downloads file
if(!file.exists("household_power_consumption.txt")){
       tempdata<-tempfile()
       download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tempdata)
       powerdata<-unzip(tempdata)
       unlink(tempdata)
}else{
       powerdata<-data.table::fread("household_power_consumption.txt")
       powerdata$Global_active_power <- as.numeric(as.character(powerdata$Global_active_power))
       powerdata$Global_reactive_power <- as.numeric(as.character(powerdata$Global_reactive_power))
}

##converts date using as.Date
powerdata$Date <- as.Date(powerdata$Date, format="%d/%m/%Y")

##focuses only on 1/2/2007 and 2/2/2007
epc<-powerdata[(powerdata$Date=="2007-02-01" | powerdata$Date=="2007-02-02")]

##creates new table
epc <-transform(epc, datetime=as.POSIXct(paste(Date, Time)), "%d%m%Y %H:%M:%S" )

##creates plot 2: linegraph
plot(epc$datetime, epc$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")

##creates png file
dev.copy(png, file="plot2.png")
dev.off()
