library(dplyr)

# Downlaod the file if not exist
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file_name_zip = "household_power_consumption.zip"
file_name = "household_power_consumption.txt"
if (!file.exists(file_name_zip)) {
  download.file(url, destfile = file_name_zip)
}

# Load the data
dat <- tbl_df(read.csv(unz(file_name_zip, file_name), sep = ";", as.is = T)) %>%
  filter(Date %in% c("1/2/2007", "2/2/2007"))

# Clean the dataset
dat[, 3:9] <- sapply(dat[, 3:9], as.numeric)

dat <- dat %>% 
  # Combine Date and Time to Datetime
  mutate(Datetime = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>% 
  select(c("Datetime", names(dat)[3:9]))

# Generate the PNG plot
png(filename = 'plot2.png', width = 480, height = 480)

with(dat, plot(Datetime, Global_active_power, type = "l", 
               xlab = "", ylab = "Global Active Power (kilowatts)"))

dev.off()