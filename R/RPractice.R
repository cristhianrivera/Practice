#install.packages(c("nycflights13", "gapminder", "Lahman"))
library("tidyverse")
p <-ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

View(mpg)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ <5, size = cty, stroke = FALSE))

#to control the transparency
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

#to control the shape of the geom_point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))



#Facets (to split betweet discrete variables)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(cyl ~ drv)

#Some about geoms (different kind of charts)
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds) + 
  geom_col(mapping = aes(x = cut, y = price))

ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(binwidth = 500)
ggplot(diamonds, aes(price, colour = cut)) +
  geom_freqpoly(binwidth = 500)

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = price),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# Coordinate systems

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()


bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

# minor filter but useful
library(tidyverse)
filter(mpg, cyl == 8)
filter(diamonds, carat > 3)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

###################Data transformation with dplyr basics#######

library(nycflights13)
library(tidyverse)

View(flights)

dec25 <- filter(flights, month == 12, day == 25)
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))

arrange(flights, desc(year), desc(month), desc(day))

select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)
#All columns except those from year to day (inclusive)
select(flights, -(year:day))
#select columns containing a given phrase
select(flights, contains("TIME"))

#Add new variables with mutate() and transmutate()
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)


summarise(flights, delay = mean(dep_delay, na.rm = TRUE))



by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

####operations with group by 

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = TRUE)

##### pipe usage ####
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")


##for not cancelled frlights
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))



###### Melt and cast ######
View(airquality)
attributes(airquality)
molted = melt(airquality, id.vars=c("Month","Day"), measure.vars=c("Ozone","Solar.R","Wind","Temp"))
molted = melt(airquality,id.vars=c("Month","Day"),measure.vars=c("Ozone","Solar.R","Wind","Temp"),na.rm=TRUE)
molted[sample(nrow(molted),10),]

head(cast(molted,...~variable, fun.aggregate = sum))

cast(molted,...~.,fun.aggregate=mean)

cast(molted, ...~., fun.aggregate = c(mean,sum))

###################PLOTLY#############

library(plotly)

View(airquality)
airquality_sept <- airquality[which(airquality$Month == 9),]
airquality_sept$Date <- as.Date(paste(airquality_sept$Month, airquality_sept$Day, 1973, sep = "."), format = "%m.%d.%Y")

p <- plot_ly(airquality_sept) %>%
  add_trace(x = ~Date, y = ~Wind, type = 'bar', name = 'Wind',
            marker = list(color = '#C9EFF9'),
            hoverinfo = "text",
            text = ~paste(Wind, ' mph')) %>%
  add_trace(x = ~Date, y = ~Temp, type = 'scatter', mode = 'lines', name = 'Temperature', yaxis = 'y2',
            line = list(color = '#45171D'),
            text = ~paste(Temp, '°F')) %>%
  layout(title = 'New York Wind and Temperature Measurements for September 1973',
         xaxis = list(title = ""),
         yaxis = list(side = 'left', title = 'Wind in mph', showgrid = FALSE, zeroline = FALSE),
         yaxis2 = list(side = 'right', overlaying = "y", title = 'Temperature in degrees F', showgrid = FALSE, zeroline = FALSE))

View(mtcars)
plot_ly(mtcars,
        type = "scatter",
        x = ~hp,
        y = ~qsec,
        split = ~cyl,
        mode = "markers+text",
        text = rownames(mtcars),
        textposition = "middle right") 




df <- data.frame(time = 1:10,
                 a = cumsum(rnorm(10)),
                 b = cumsum(rnorm(10)),
                 c = cumsum(rnorm(10)))
df <- melt(df ,  id.vars = 'time', variable.name = 'series')