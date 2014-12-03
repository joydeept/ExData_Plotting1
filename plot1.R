


plot1 <-
{
 
  ### Read in data file
  ###
  ### Can't really find a good way to read in just the required rows, so reading in the whole data set for subsetting.
  
  d <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?", as.is = c(1,2))
  ### Using as.is to read first two columns as characters instead of factor
  
  ### Subset only the rows containing dates 2007-02-01 and 2007-02-02
  ### 1st column is Date: Date in format dd/mm/yyyy 
  
  d <- d[grep("^1/2/2007|^2/2/2007", d[,1]),]
  
  ### Convert Date and Time columns
  
  
  ### Open PNG device
  png(filename="plot1.png", width = 480, height = 480)
  
  ### Plot the histogram
  hist(d$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

  ### Close the PNG device
  dev.off()
}