


plot3 <-
{
 
  ######## Generic but inefficient data file reading
  #
  ### I could not find a good generic way of reading in just the required rows instead of entire data set.
  ### Reading the entire file using read.table takes about 30 seconds on my PC.
  #
  #d <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?", as.is = c(1,2))
  ### Using as.is to read first two Date and Time columns as characters instead of factor 
  ### 30 second read time.
  ### Subset only the rows containing dates 2007-02-01 and 2007-02-02
  ### 1st column is Date: Date in format dd/mm/yyyy 
  #d <- d[grep("^1/2/2007|^2/2/2007", d[,1]),]
  #
  ########
  
  
  ######## Better file reading, but assumes Windows, Mac or Unix OS.
  ###
  ### 
  ### The fread() function in data.table package allows pre-processing a file using system commands.
  ### I am assuming the code will be run on either a Windows (findstr), Mac (grep) or Unix (grep) platform. 
  ### Using fread() reduced read time to 10 seconds.
  ###
  ### 
  
  library(data.table)
  
  ### Detect operating system
  if (Sys.info()[1] == "Windows") 
    os_command <- "findstr /b \"[12]/2/2007\" household_power_consumption.txt"
  else
    os_command <- "grep \"^[12]/2/2007\" household_power_consumption.txt"
  
  ### Selectively read only requried lines.
  d <- fread(os_command, 
             sep=";", 
             na.strings="?",
             colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
             data.table = FALSE)
  ### Header - read just the first line to get column names 
  h <- read.table("household_power_consumption.txt", nrow=1, header=TRUE, sep=";")
  setnames(d, names(h))
  
  ### Concatenate Date and Time columns, convert to POSIXct and form a new data frame
  dt <- data.frame(strptime(paste(d$Date, d$Time), "%d/%m/%Y %H:%M:%S"))
  names(dt) <- c("DateTime")
  d <- cbind(dt, d[,3:9])
  
  ### Open PNG device
  png(filename="plot3.png", width = 480, height = 480)
  
  ### Plot the three series one by one
  plot(d$DateTime, d$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", col="black" )
  lines(d$DateTime, d$Sub_metering_2, col="red" )
  lines(d$DateTime, d$Sub_metering_3, col="blue" )
  
  ### Add the legend
  legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = (c("black", "red", "blue")), lty=1)
  
  ### Close the PNG device
  dev.off()
}