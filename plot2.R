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

png(filename = "plot2.png", width = 480, height = 480)
plot(
    data$Date.Time,
    data$Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power (kilowatts)"
)
dev.off()