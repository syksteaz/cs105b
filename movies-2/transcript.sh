#!/bin/bash

echo "(PA) Movies Part 2 - this will take a while!"

echo "Running my movie_data.rb:"

echo "Top 10, mean"

./movie_data.rb ml-100k:u1 -mean 10

echo "Top 10, STDEV"

./movie_data.rb ml-100k:u1 -stdev 10

