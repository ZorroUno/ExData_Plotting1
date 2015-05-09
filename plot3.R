# Check if a data folder already exists.
# If not, create it
if (!file.exists("./data")){
    dir.create("./data")
}
# Check if the file exists.
# If not, download and extract it
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_filename <- "./data/household_power_consumption.zip"
txt_filename <- "./data/household_power_consumption.txt"
if (!file.exists(txt_filename)){
    # NOTE: culr method is necessary in linux
    download.file(fileUrl, destfile = zip_filename, method = "curl")
    unzip(zipfile = zip_filename, exdir = "./data/")
}

# Load data, using "?" as NA, and ";" as separator
data <- read.table(
    txt_filename,
    header = TRUE,
    sep = ";",
    na.strings = "?")
# Convert Date and Time columns to a DateTime class
data$DateTime <- strptime(
    apply(
        data[, c("Date", "Time")],
        1,
        paste,
        collapse = " "),
    format="%d/%m/%Y %H:%M:%S")
# Subset data between the first and second date
sub <- subset(
    data[c("DateTime", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")],
    data$Date == "1/2/2007" | data$Date == "2/2/2007")
# Create the png file
png("plot3.png", width = 480, height = 480, units="px")
# Create a plot with the subset
plot(sub$DateTime,
     sub$Sub_metering_1,
     type = "l",
     ylab= "Energy sub metering",
     xlab = "")
points(sub$DateTime, sub$Sub_metering_2, type = "l", col = "red")
points(sub$DateTime, sub$Sub_metering_3, type = "l", col = "blue")
legend("topright",
       lty = c(1,1),
       col = c("black", "red", "blue"),
       legend = names(sub)[2:4])
# Close the device (png file)
dev.off()