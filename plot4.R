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
# Convert columns 3:9 from character to numeric
dat[, 3:9] <- sapply(dat[, 3:9], as.numeric)

dat <- dat %>% 
  # Combine Date and Time to Datetime
  mutate(Datetime = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>% 
  select(c("Datetime", names(dat)[3:9]))

# Generate the PNG plot
png(filename = 'plot4.png', width = 480, height = 480)

par(mfrow = c(2, 2), oma = c(0, 0, 2, 0), mar = c(4.5, 7, 0, 2))

with(dat, plot(Datetime, Global_active_power, type = "l", 
               xlab = "", ylab = "Global Active Power"))

with(dat, plot(Datetime, Voltage, type = "l", 
               xlab = "datetime", ylab = "Voltage"))

plot(dat$Datetime, dat$Sub_metering_1, type = "n", 
     xlab = "", ylab = "Energy sub metering")
lines(dat$Datetime, dat$Sub_metering_1, col = "black")
lines(dat$Datetime, dat$Sub_metering_2, col = "red")
lines(dat$Datetime, dat$Sub_metering_3, col = "blue")
legend("topright", lwd = 1, col = c("black", "red", "blue"), cex=0.7, bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(dat, plot(Datetime, Global_reactive_power, type = "l", 
               xlab = "datetime", ylab = "Global_reactive_power"))

dev.off()