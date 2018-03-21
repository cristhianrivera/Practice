setwd("C:/Users/a688291/Documents/EDA_CRJR/the-interview-attendance-problem")
data <- read_csv("Interview.csv")
data <- as.data.frame(data)

data_industry <- select(data, "Industry")


##### for industry ####
data_industry <- data %>% 
  group_by(Industry, Gender, `Observed Attendance`) %>% 
  summarise(
    count = n()
  )

ggplot(data_industry)+
  geom_col(aes(x = `Observed Attendance`, y = count))