library(dplyr)

# Downlaod the file if not exist
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file_name_zip = "household_power_consumption.zip"
file_name = "household_power_consumption.txt"
if (!file.exists(file_name_zip)) {
  download.file(url, destfile = file_name_zip)
}

# Load the data
dat <- tbl_df(read.csv(unz(file_name_zip, file_name), sep = ";", as.is = T))

# Clean the dataset
# Convert columns 3:9 from character to numeric
dat[, 3:9] <- sapply(dat[, 3:9], as.numeric)

dat <- dat %>% 
  # Combine Date and Time to Datetime
  mutate(Datetime = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>% 
  select(c("Datetime", names(dat)[3:9])) %>%
  # Filter for the 2-day period
  filter(Datetime >= as.POSIXct("2007-02-01", format = "%Y-%m-%d") & 
           Datetime < as.POSIXct("2007-02-03", format = "%Y-%m-%d"))

# Plotting
plot(dat$Datetime, dat$Sub_metering_1, type = "n", 
     xlab = "", ylab = "Energy sub metering")
lines(dat$Datetime, dat$Sub_metering_1, col = "black")
lines(dat$Datetime, dat$Sub_metering_2, col = "red")
lines(dat$Datetime, dat$Sub_metering_3, col = "blue")
legend("topright", lwd = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Generate the PNG plot
dev.copy(png, "plot3.png")
dev.off()