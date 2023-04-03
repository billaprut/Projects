
library(tidyverse)

# define a function to calculate accuracy
accuracy <- function(classifications, actuals){
  correct_classifications <- ifelse(classifications == actuals, 1, 0)
  acc <- sum(correct_classifications)/length(classifications)
  return(acc)
}

# Load a smaller version of the movies data
# Turn all factors into factors
movies <- read_csv("movies_cleaned_small.csv") %>%
  mutate(IMDB_high = as.factor(IMDB_high),
         genre = as.factor(genre))

summary(movies)

##Split the data into training and validation data
set.seed(1)

## Partition 30% of the data as validation data
valid_instn = sample(nrow(movies), 0.30*nrow(movies))
movies_valid <- movies[valid_instn,]
movies_train <- movies[-valid_instn,]

##How many instances are in train/test/validation sets?

## Use the tree library
#make sure that you've done:
#install.packages("tree")
library(tree)

## Train a classification tree
default_tree=tree(IMDB_high ~ gross+budget+title_year+genre, movies_train)
summary(default_tree)
plot(default_tree)
text(default_tree)

## This is not an easy-to-read, nice-looking tree! Try to make it look nicer
plot(default_tree)
text(default_tree,pretty=1)

plot(default_tree)
text(default_tree,pretty=2)

plot(default_tree)
text(default_tree,pretty=10)

default_tree

levels(movies$IMDB_high)

mycontrol = tree.control(nobs = nrow(movies_train), mincut = 1, minsize = 2, mindev = 0)
full_tree <- tree(IMDB_high ~ gross+title_year+budget+genre,
                         data = movies_train, 
                         control = mycontrol)

summary(full_tree)
plot(full_tree)

full_tree$frame

total_nodes <- nrow(full_tree$frame)

leaves <- full_tree$frame %>%
  filter(var == '<leaf>')
terminal_nodes <- nrow(leaves)

decision_nodes <- total_nodes - terminal_nodes

## This tree is too complicated
## Let's prune it back to have only 10 terminal nodes
pruned_tree_10=prune.tree(full_tree, best = 10)
summary(pruned_tree_10)
plot(pruned_tree_10)
text(pruned_tree_10,pretty=1)

pruned_tree_10

## Let's use the tree to do probability predictions for the validation data
tree_preds <- predict(pruned_tree_10,newdata=movies_valid)

tree_preds

## We only want the Y=1 probability predictions
tree_probs=tree_preds[,2]
