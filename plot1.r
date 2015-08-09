##checks to see if file is downloaded; if it is continues, otherwise downloads file
if(!file.exists("exdata-data-household_power_consumption.zip")){
       tempdata<-tempfile()
       download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tempdata)
       powerdata<-unzip(tempdata)
       unlink(tempdata)
}
##reads table
epc<-read.table(powerdata, header=T, sep=";", na.strings="?")
##focuses only on 1/2/2007 and 2/2/2007
epc2<-epc[as.character(epc$Date) %in% c("1/2/2007", "2/2/2007"),]
##creates new table
epc2$dt=paste(epc2$Date, epc2$Time)

##converts Time and attaches
epc2$dt<-strptime(epc2$dt, "%d%m%Y %H:%M:%S")
attach(epc2)

##creates plot 1 histogram
hist(epc2$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", 
     ylab="Frequency", main="Global Active Power", xlim=c(0,6), ylim=c(0,1200) )

##creates png file
dev.copy(png, file="plot1.png")
dev.off()
