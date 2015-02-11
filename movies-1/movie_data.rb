#!/usr/bin/env ruby
#Eden Zik
#MovieData processor program
#v1.0

#load_data - this will read in the data from the original ml-100k files and stores them in whichever way it needs to be stored
#popularity(movie_id) - this will return a number that indicates the popularity (higher numbers are more popular). You should be prepared to explain the reasoning behind your definition of popularity
#popularity_list - this will generate a list of all movie_id’s ordered by decreasing popularity
#similarity(user1,user2) - this will generate a number which indicates the similarity in movie preference between user1 and user2 (where higher numbers indicate greater similarity)
#most_similar(u) - this return a list of users whose tastes are most similar to the tastes of user u

#usage: ./movie_data <ml-100k file location> {-h|-popularity movie_id|-popularity_list|-similarity user1 user2|-most_similar user}

class MovieData
	def initialize()
		@movie_rating, @person_movies_rating = Hash.new(), Hash.new	#stores the rating for each movie, stores the rating each person gave to each movie
	end  
	def load_data(filename)	#Reads all rating data 
		open(filename).each_line do |line|						#iterates over all lines in a file
			splitLine = line.split("\t")						#splits the line
			user_id, item_id, rating = splitLine.shift.to_i, splitLine.shift.to_i, splitLine.shift.to_f
			@person_movies_rating[user_id] ||= Hash.new()		#sets a variable if nill
			@person_movies_rating[user_id][item_id] = rating	#sets the persons rating of the movie
			@movie_rating[item_id] ||= [0,0]			#if movie rating hasn't been intalized, make a new sum / # of raters pai
			@movie_rating[item_id] = [@movie_rating[item_id][0] + rating, @movie_rating[item_id][1]+1]	#increment its value
		end
	end
	def popularity(movie_id)
		@movie_rating[movie_id.to_i].first
	end
	def popularity_list	#sorts all movies by descending popularity, the simple sum of all their ratings
		return sorted_list = @movie_rating.sort_by {|key, value| -value.first}.map{|key, value| key}	
	end
	def similarity(user1,user2) #euclidean distance metric between two users, measured as (1+sqrt((rating_user_1_for_movie_n - rating_user_2_for_movie_n)^2))/(number of ratings)
		user1_movies, user2_movies = @person_movies_rating[user1.to_i], @person_movies_rating[user2.to_i]
		intersection = (user1_movies.keys & user2_movies.keys).map{|key| (user1_movies[key].to_f - user2_movies[key].to_f)**2} #finds intersection, computes eucledian distance
		return intersection.empty? ? 0 : intersection.size/(intersection.reduce{|sum, n| sum+Math.sqrt(n)} + 1)					#part of the formula, 0 if no movies in common
	end
	def most_similar(u)			#returns a sorted list of people sorted by most to least similar (not including ones without any in common)
		similarity_with_u = Hash.new()
		@person_movies_rating.keys.compact.each{|user| similarity_with_u[user] = similarity(u, user)}
		return similarity_with_u.select{|key, value| value!=0 }.sort_by{ |key, value| -value}.map{|key,value| key}
	end
end

if ARGV.empty?
	puts 'usage: ./movie_data <ml-100k file location> {-h|-load_data|-popularity movie_id|-popularity_list|-similarity user1 user2|-most_similar user}'
else	
	begin
		mv = MovieData.new()
		mv.load_data(ARGV.shift)
	rescue
		puts 'File not found'
	end
	begin
		case ARGV.shift
		when '-h'
			puts 'MovieData Processor Program:
			load_data - this will read in the data from the original ml-100k files and stores them in whichever way it needs to be stored
			popularity(movie_id) - this will return a number that indicates the popularity (higher numbers are more popular). You should be prepared to explain the reasoning behind your definition of popularity
			popularity_list - this will generate a list of all movie_id’s ordered by decreasing popularity
			similarity(user1,user2) - this will generate a number which indicates the similarity in movie preference between user1 and user2 (where higher numbers indicate greater similarity)
			most_similar(u) - this return a list of users whose tastes are most similar to the tastes of user u'
		when '-load_data'
			puts 'data loaded.'
		when '-popularity'
			puts mv.popularity(ARGV.shift)
		when '-popularity_list'
			puts mv.popularity_list
		when '-similarity'
			puts mv.similarity(ARGV.shift, ARGV.shift)
		when '-most_similar'
			puts mv.most_similar(ARGV.shift)
		else
			puts 'Command not found.'
		end
	rescue
		puts 'Bad or missing arguments'
	end
end








