#!/bin/bash

echo "(PA) Movies Part 1"

echo "Running my movie_data.rb:"

echo "10 Most Popular:"

./movie_data.rb ml-100k/u.data -popularity_list | head -10

echo "10 Least Popular:"

./movie_data.rb ml-100k/u.data -popularity_list | tail -10

echo "Similarity to 1 in descending order"

./movie_data.rb ml-100k/u.data -most_similar 1