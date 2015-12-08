library(sqldf)

# Download data
data.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20dataset.zip'
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
