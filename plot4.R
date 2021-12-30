# Load sqldf to enable partial read of CSV
library(sqldf)
# Load tidyverse to work with tibbles
library(tidyverse)

# Load only records for 2007-02-01 and 2007-02-02
data <- read.csv.sql(
    "household_power_consumption.txt",
    sql = "select * from file where Date in ('1/2/2007', '2/2/2007')",
    sep = ";"
)

# Convert to tibble
data <- as_tibble(data)

# Convert Date and Time columns into a datetime
data <- data %>%
    unite("Date.Time", Date:Time) %>%
    mutate(Date.Time = as.POSIXct(Date.Time, format = "%d/%m/%Y_%H:%M:%S"))

par(mfrow = c(2, 2))

plot(
    data$Date.Time,
    data$Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power"
)

plot(
    data$Date.Time,
    data$Voltage,
    type = "l",
    xlab = "datetime",
    ylab = "Voltage"
)

plot(
    data$Date.Time,
    data$Sub_metering_1,
    type = "l",
    xlab = "",
    ylab = "Energy sub metering"
)
with(
    data, {
        lines(Date.Time, Sub_metering_2, col = "red")
        lines(Date.Time, Sub_metering_3, col = "blue")
    }
)
legend(
    "topright",
    names(data[, 6:8]),
    col = c("black", "red", "blue"),
    text.width = strwidth("Sub_metering_3")[1] * 2,
    lty = 1,
    bty = "n"
)

plot(
    data$Date.Time,
    data$Global_reactive_power,
    type = "l",
    xlab = "datetime",
    ylab = "Global_reactive_power"
)
axis(2, at = seq(0.1, 0.5, 0.1))
