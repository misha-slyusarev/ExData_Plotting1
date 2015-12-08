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

# Plot a graph of power cunsumption by time
yLabel = 'Global active power (kilowatts)'
with(data, plot(Time, Global_active_power, type = 'l', ylab = yLabel, xlab = ''))

# Save the plot to PNG
dev.copy(png, file = "plot2.png", height = 480, width = 480)
dev.off()