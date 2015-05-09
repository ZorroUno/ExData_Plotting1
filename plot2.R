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
sub <- subset(data[c("DateTime", "Global_active_power")],
       data$Date == "1/2/2007" | data$Date == "2/2/2007")
# Create a plot with the subset
plot(sub, type = "l", ylab = "Global Active Power (killowatts)", xlab = "")
# Copy the histogram to a png file
dev.copy(png, file="plot2.png")
dev.off()