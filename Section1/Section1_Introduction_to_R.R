# EEP 161 - Advanced Topics in Environmental and Resource Economics (Spring 2025)
# Section 1: Introduction to R and RStudio

# Installing R and RStudio
# Download and install **BOTH** R and RStudio.
# - To download R: https://cloud.r-project.org/
# - To download RStudio: https://posit.co/download/rstudio-desktop/#download

# R Objects
# Create an object
a <- 1
print(a)

# Remove an object
rm(a)

# Clear environment
rm(list=ls())

# Working Directory
# Check current working directory
getwd()

# Set working directory
# Replace <YOUR PATH> with the actual path
setwd("C:/Users/shuoy/Dropbox/EEP161/Sections/Section1")

# Comments in R
# R will skip lines that start with `#`
a <- 2
# a <- 1
print(a)

# Variable Types
# Create and check types
num <- 3.14
class(num)

txt <- "hello"
class(txt)

flag <- TRUE
class(flag)

int <- 10L
class(int)

category <- factor(c("A", "B", "A"))
class(category)

# Type conversions
num <- as.numeric("42")
text <- as.character(42)

# Simple Calculations
2 + 3
10 - 4
5 * 6
20 / 4
2^3
sqrt(16)

# Order of operations
(2 + 3) * 4

# Error example
# Uncomment the following line to test
# "text" + 1

# Vectors
# Create vectors
yields <- c(7.5, 4.2, 3.8)
crops <- c("corn", "wheat", "soybean")
is_large_field <- c(TRUE, FALSE, TRUE)

# Access vector elements
yields[1]
crops[3]

# Vectorized operations
yields + 1
yields * 2
yields > 4

# Data Frames
# Creating a data frame
data <- data.frame(
  Crop = crops,
  Yield = yields,
  LargeField = is_large_field
)

# Access data frame components
data$Yield
data[1, ]
data[, 2]
data[1, 2]
data[data$Yield > 4, ]

# View structure and summary
str(data)
summary(data)

# Installing and Loading Packages
# Install a package
install.packages("tidyverse")

# Load a package
library(tidyverse)

# Pipe Operator (`%>%`)
# Without pipes
filtered <- data[data$Yield > 4, ]
AvgYield <- mean(filtered$Yield)
print(data.frame(AvgYield = AvgYield))

# With pipes
data %>%
  filter(Yield > 4) %>%
  summarize(AvgYield = mean(Yield)) %>%
  print()

# Working with External Data
# Load dataset
Daily_price <- read.csv("Daily_prices.csv")

# Preview dataset
head(Daily_price)

# View all rows/columns
view(Daily_price)

# Summary of dataset
summary(Daily_price)
