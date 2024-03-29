library(tidyverse)

library(modelr)
options(na.action = na.warn)


ggplot(sim1, aes(x, y)) + 
  geom_point()

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

model1 <- function(a, data) {
  a[1] + data$x * a[2] + a[3]
}

View(sim1)
model1(c(7, 1.5), sim1)

#distance 
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

#distance 1
measure_distance1 <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  mean(abs(diff))
}



measure_distance(c(7, 1.5), sim1)

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(models, rank(dist) <= 10)
  )

#build a grid 
View(grid)
grid <- expand.grid(
  a1 = seq(-5, 20, length = 30),
  a2 = seq(1, 3, length = 30)) %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% 
  ggplot(aes(a1, a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist)) 


ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(grid, rank(dist) <= 5)
  )

#Newton Raphson optimization for finding the best line
best <- optim(c(0, 0), measure_distance, data = sim1)
best1 <- optim(c(0, 0), measure_distance1, data = sim1)



ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2], color = "blue")+
  geom_abline(intercept = best1$par[1], slope = best1$par[2], color = "black")


sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)

attributes(sim1_mod)


#visualize a simple model
grid <- sim1 %>% 
  data_grid(x) 

grid <- grid %>% 
  add_predictions(sim1_mod) 


ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

#Residuals
sim1 <- sim1 %>% 
  add_residuals(sim1_mod)

ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0, colour = "light blue") +
  geom_point() 



df <- dplyr::tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1 )


#model for categorical variables
df <- dplyr::tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)
model_matrix(df, response ~ sex)

mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid

#model for categorical and continuos variables
ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))


mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid

sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)

#model for continuos (2) variables

mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5), 
    x2 = seq_range(x2, 5) 
  ) %>% 
  gather_predictions(mod1, mod2)


ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)


ggplot(grid, aes(x1, pred, colour = x2, group = x2)) + 
  geom_line() +
  facet_wrap(~ model)
ggplot(grid, aes(x2, pred, colour = x1, group = x1)) + 
  geom_line() +
  facet_wrap(~ model)

##important transformations inside the formulas
model_matrix(df, y ~ x^2 + x)
model_matrix(df, y ~ I(x^2) + x)
model_matrix(df, y ~ poly(x, 2))


#SPLINES

df <- tribble(
  ~y, ~x,
  1,  1,
  2,  2, 
  3,  3
)
library(splines)
model_matrix(df, y ~ ns(x, 2))


sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 1000),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()

mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>% 
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")

ggplot(sim5, aes(x, y)) + 
  geom_point() +
  geom_line(data = grid, colour = "red") +
  facet_wrap(~ model)



#### missing values
df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df, na.action = na.warn) # warning when dropping out missing values
nobs(mod)



#dplyr::filter(InterviewData,grepl("java", tolower(InterviewData$Nature.of.Skillset)) )