library(sqldf)

# Download data
data.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
data.filename <- 'household_power_consumption.txt'

if( ! file.exists(data.filename) ){
  temp_zip <- tempfile()
  download.file(data.url, temp_zip)
  unzip(temp_zip)
  unlink(temp_zip)
}

# Find out column types to speed up reading from file
data.initial <- read.csv(data.filename, sep = ';', nrows = 1)
columnClasses <- sapply(data.initial, class)

# Read data to memory with filtering by certain dates
data <- read.csv.sql(data.filename, 
                     "select * from file where Date in ('1/2/2007', '2/2/2007')", 
                     sep=';', colClasses = columnClasses)

# Convert Date & Time fields from chr to Date & Time data types
data <- within(data, {
  Time <- strptime(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")
  Date <- as.Date(Date, '%d/%m/%Y')
})

# Setup global graph settings to
# place single picture and adjust margin
par(mfrow = c(1, 1), mar = c(3, 5, 2, 2))

# Plot a graph of sub metering by time
yLabel = 'Energy sub metering'
with(data, {
  plot(Time, Sub_metering_1, type = 'l', ylab = yLabel, xlab = '', col = 'grey')
  points(Time, Sub_metering_2, type = 'l', col = 'red')
  points(Time, Sub_metering_3, type = 'l', col = 'blue')
  legend("topright", 
         legend = c('Sub metering 1', 'Sub metering 2', 'Sub metering 3'), 
         col = c('grey', 'red', 'blue'), lty = 1)
})

# Save the plot to PNG
dev.copy(png, file = "plot3.png", height = 480, width = 480)
dev.off()