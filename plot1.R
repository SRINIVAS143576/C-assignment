library(dplyr)

# Load the data
file_name = "./data/household_power_consumption.txt"
dat <- tbl_df(read.csv(file_name, sep = ";", as.is = T))

# Clean the dataset
dat[, 3:9] <- sapply(dat[, 3:9], as.numeric)

dat <- dat %>% 
  # Combine Date and Time to Datetime
  mutate(Datetime = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>% 
  select(c("Datetime", names(dat)[3:9])) %>%
  # Filter for the 2-day period
  filter(Datetime >= as.POSIXct("2007-02-01", format = "%Y-%m-%d") & 
           Datetime < as.POSIXct("2007-02-03", format = "%Y-%m-%d"))

# Plotting
hist(dat$Global_active_power, col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", 
     main = "Global Active Power")

# Generate the PNG plot
dev.copy(png, "plot1.png")
dev.off()