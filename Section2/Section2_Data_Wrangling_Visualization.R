# EEP 161 - Advanced Topics in Environmental and Resource Economics (Spring 2025)
# Section 2: Data Wrangling and Visualization

rm(list=ls())

# Load required packages
library(tidyverse)

# Load tidyverse documentation
?tidyverse

# Set working directory
setwd("C:/Users/shuoy/Dropbox/161/Sections/Section2")

# Read data
# Example: Read egg price data
df <- read.csv("DailyPrices.csv")

# Display first several rows of the dataframe
head(df)

# View entire dataframe
View(df)

# Glimpse the dataframe 
# What's the difference between head() and glimpse()?
glimpse(df)

# Summary statistics of the dataframe
summary(df)

# Select columns
selected_df <- df %>%
  select(Date, Low.Price, High.Price)
colnames(selected_df)

selected_df <- df %>% 
  select(Date:High.Price)
colnames(selected_df)

selected_df <- df %>% 
  select(!c(Low.Price, High.Price))
colnames(selected_df)

selected_df <- df %>%
  select(-Low.Price, -High.Price)
colnames(selected_df)

reordered_df <- df %>%
  select(Low.Price, everything())
colnames(reordered_df)

selected_df <- df %>%
  select(starts_with("D"))
colnames(selected_df)

selected_df <- df %>%
  select(ends_with("e"))
colnames(selected_df)

selected_df <- df %>%
  select(contains("Price"))
colnames(selected_df)

selected_df <- df %>%
  select(matches("^L.+e$")) # Regular expressions
colnames(selected_df)

# Filter rows
df_filtered <- df %>%
  filter(Low.Price == 171)
summary(df_filtered)

df_filtered <- df %>%
  filter(Market.Name != "CALIFORNIA")
table(df_filtered$Market.Name)

df_filtered <- df %>%
  filter(Egg.Class %in% c("LARGE", "JUMBO"))
table(df_filtered$Egg.Class)

df_filtered <- df %>%
  filter(Low.Price >= 200 & High.Price <= 200)
summary(df_filtered)

df_filtered <- df %>%
  filter(Low.Price >= 200 | High.Price <= 200)
summary(df_filtered)

df_filtered <- df %>%
  filter(!is.na(Mostly.Low))
summary(df_filtered)

# Practice
df_filtered <- df %>%
  select(Date, Market.Name, Egg.Class, Low.Price, High.Price) %>%
  filter(Egg.Class %in% c("LARGE", "JUMBO"))

dim(df)
dim(df_filtered)

# Mutate new columns
df_new <- df %>% 
  select(Date, Market.Name, Low.Price, High.Price) %>%
  mutate(Avg.Price = (Low.Price + High.Price) / 2, 
         Price.Group = cut(Avg.Price, c(0, 200, 400, 600, 800, 1000)),
         High.Price.Flag = if_else(Low.Price > 150, "Above 150", "Below 150"))

unique(df_new$Price.Group)
head(df_new)

# Arrange data
df_arrange <- df %>%
  arrange(Low.Price)
head(df_arrange)

df_arrange <- df %>%
  arrange(desc(Low.Price))
head(df_arrange)

df_arrange <- df %>%
  arrange(Market.Name, desc(Low.Price))
head(df_arrange)

df_arrange <- df %>%
  arrange(desc(!is.na(Low.Price)), Low.Price)
head(df_arrange)

# Group and summarize
df_group <- df %>%
  group_by(Market.Name)

glimpse(df_group)
group_keys(df_group)

df_summarize <- df %>%
  summarize(avg_low_price = mean(Low.Price))
df_summarize

df_summarize <- df %>%
  filter(!is.na(Low.Price)) %>%
  summarize(avg_low_price = mean(Low.Price))
df_summarize

df_summarize <- df %>%
  filter(!is.na(Low.Price)) %>%
  group_by(Market.Name) %>%
  summarize(avg_low_price = mean(Low.Price), count = n())
df_summarize

# Practice
extra_large_avg <- df %>%
  group_by(Market.Name) %>%
  filter(Egg.Class == "EXTRA LARGE") %>%
  summarize(Average.Low.Price = mean(Low.Price, na.rm = TRUE))
print(extra_large_avg)

large_egg_prop <- df %>%
  filter(Egg.Class == "LARGE") %>%
  group_by(Market.Name) %>%
  summarize(
    Proportion = sum(High.Price >= 200 & High.Price <= 500, na.rm = TRUE) / n()
  )
print(large_egg_prop)

# Data Visualization
df$Date <- as.Date(df$Date, format = "%Y-%m-%d")

start_date <- as.Date("2019-01-01")

plot_prices <- df %>%
  arrange(Date) %>%
  filter(Date >= start_date) %>%
  filter(Egg.Class %in% c("LARGE")) %>%
  filter(Market.Name %in% c("CALIFORNIA","IOWA-MINNESOTA-WISCONSIN")) %>%
  mutate(Market.Name = str_to_title(
    ifelse(Market.Name == "IOWA-MINNESOTA-WISCONSIN", "Midwest", Market.Name))) %>%
  mutate(Price = (Low.Price + High.Price) / 2) %>%
  ggplot(
    aes(
      x = Date,
      y = Price,
      color = factor(Market.Name, levels = c("California", "Midwest")))) +
  geom_line(linewidth = 1) +
  labs(x = "", 
       y = "Cents per Dozen", 
       color = "State", 
       caption = "Source: https://www.marketnews.usda.gov/mnp/py-report-config?category=Egg\n https://agdatanews.substack.com") +
  ggtitle("Wholesale Large Egg Prices") +
  theme_minimal() +
  scale_color_brewer(palette = "Dark2") +
  theme(plot.title = element_text(hjust = 0.5, size = 16), text = element_text(size = 12))

plot_prices

ggsave(paste0("daily_egg_prices_2024_", start_date, ".png"), bg = "white")
