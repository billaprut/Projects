library(tidyverse)

movie_data <- read_csv('movie_training.csv') 

data_clean <- movie_data %>% 
  select(gross, title_year, budget, IMDB_score, genres, 
         duration, country, content_rating,
         movie_title) %>%
  filter(!is.na(IMDB_score)) %>%
  mutate(gross = ifelse(is.na(gross), mean(gross, na.rm=TRUE), gross)/1000000,
         budget = ifelse(is.na(budget), mean(budget, na.rm=TRUE), budget)/1000000,
         duration = ifelse(is.na(duration), mean(duration, na.rm=TRUE), duration)) %>%
  separate(genres, into = ("genre"), extra = "drop") %>%
  group_by(genre) %>% #group_by+mutate is handy - directly compute aggregate values
  mutate(n_movies = n(),
         genre = ifelse(n_movies <= 25, 'Other', genre),
         genre = as.factor(genre)) %>%
  ungroup() %>%
  group_by(content_rating) %>% #group_by+mutate is handy - directly compute aggregate values
  mutate(n_movies = n(),
         rating = ifelse(n_movies <= 25, 'Other', content_rating),
         rating = ifelse(rating %in% c("Not Rated", "Unrated"), 'Other', rating),
         rating = ifelse(is.na(rating), 'Other', rating),
         rating = as.factor(rating)) %>%
  ungroup() %>%
  select(-content_rating) %>%
  group_by(rating) %>%
  mutate(avg_budget = mean(budget),
         expensive = as.factor(ifelse(budget > avg_budget, "YES", "NO"))) %>%
  select(movie_title, gross, budget, title_year, duration, genre, rating, expensive, 
         IMDB_score)

summary(data_clean)

# Let's run linear regression only on our numerical variables
model1 <- lm(data = data_clean, IMDB_score ~ gross + title_year + budget)
summary(model1)

# Add in a categorical variable
model2 <- lm(data = data_clean, IMDB_score ~ gross + title_year + budget + rating)
summary(model2)


dm_movie <- data.frame(gross = 1000, title_year = 2023, budget = 1)
est_IMDB <- predict(model1, newdata = dm_movie)

# Random seed makes sure everyone gets the same random numbers
set.seed(1)

# sample(max, n) will randomly select n instances from a list spanning from 1 to max
train_insts = sample(nrow(data_clean), .7*nrow(data_clean))

# What do these two lines do?
data_train <- data_clean[train_insts,]
data_valid <- data_clean[-train_insts,]

# Goal here is to estimate predictive performance on the validation set.
# We want to compare three model specifications from above - need to train on the train instances only.

model1_tr <- lm(data = data_train, IMDB_score ~ gross + title_year + budget )
model2_tr <- lm(data = data_train, IMDB_score ~ gross + title_year + budget + rating)
model3_tr <- lm(data = data_train, IMDB_score ~ gross + title_year + budget + rating + gross*rating)


# Make predictions and calculate RMSE on validation data
m1_predict <- predict(model1_tr, newdata = data_valid)
m1_RMSE <- sqrt(mean((m1_predict - data_valid$IMDB_score)^2))

