#!/usr/bin/env ruby
#Eden Zik
#MovieData processor program
#v2.0

#load_data - this will read in the data from the original ml-100k files and stores them in whichever way it needs to be stored
#popularity(movie_id) - this will return a number that indicates the popularity (higher numbers are more popular). You should be prepared to explain the reasoning behind your definition of popularity
#popularity_list - this will generate a list of all movie_id’s ordered by decreasing popularity
#similarity(user1,user2) - this will generate a number which indicates the similarity in movie preference between user1 and user2 (where higher numbers indicate greater similarity)
#most_similar(u) - this return a list of users whose tastes are most similar to the tastes of user u

usage: ./movie_data <ml-100k[:u1] file location> {-h|-popularity movie_id|-popularity_list|-similarity user1 user2|-most_similar user|-predict|-test|-movies|-viewers|-run_test|-mean|-variance|-stdev}

class MovieData
	class Movie
		def initialize(id)
			@id = id
			@users = Hash.new
		end
		def add_user_rating(user, rating)
			@users[user] = rating
		end
		def popularity
			return @users.values.reduce(:+)
		end
		def get_id
			return @id
		end
		def get_users
			return @users
		end
	end
	class User
		def initialize(id)
			@id = id
			@movies = Hash.new
		end
		def add_movie_rating(movie, rating)
			@movies[movie] = rating
		end
		def get_id
			return @id
		end
		def get_movies
			return @movies
		end
		def to_s
			return get_id
		end
	end
	def initialize(*args)
		filepath, filename = args.shift, args.shift
		filename ? load_training(filepath, filename) : load_default(filepath)
	end
	def get_movie(movie)
		return @movies[movie]
	end
	def get_user(user)
		return @users[user]
	end
	def retrieve_user(user)
		return get_user(user.get_id)
	end
	def retrieve_movie(movie)
		return get_movie(movie.get_id)
	end
	def load_training(filepath, filename)							#loads training data
		read_result = load_data(filepath + "/" + filename + ".base")
		@movies, @users = read_result.shift, read_result.shift
		read_result = load_data(filepath + "/" + filename + ".test")
		@movies_test, @users_test = read_result.shift, read_result.shift
	end
	def load_default(filepath)
		read_result = load_data(filepath + "/" + "u.data")
		@movies, @users = read_result.shift, read_result.shift
	end
	def load_data(file)	#Reads all rating data
		movies = Hash.new
		users = Hash.new
		open(file.to_s).each_line do |line|	#iterates over all lines in a file
			splitLine = line.split("\t")
		#	puts line
			user, movie, rating = splitLine.shift.to_i, splitLine.shift.to_i, splitLine.shift.to_i
			users[user] ||= User.new(user)									#enqueues into hash
			movies[movie] ||= Movie.new(movie)
			users[user].add_movie_rating(movies[movie],rating)
			movies[movie].add_user_rating(users[user], rating)
		end
		return [movies, users]
	end
	def popularity(movie)
		return movie.popularity
	end
	def popularity_list
		return @movies.sort_by {|movie, rating| -popularity(movie)}.map{|popularity,movie| movie}
	end
	def similarity(user1,user2) 
		user1_movies, user2_movies = user1.get_movies, user2.get_movies
		#puts user2_movies.to_s
			intersection = (user1_movies.keys & user2_movies.keys).map{|key| (user1_movies[key].to_f - user2_movies[key].to_f)**2} 		#finds intersection, computes eucledian distance
		return intersection.empty? ? 0 : intersection.size/(intersection.reduce{|sum, n| sum+Math.sqrt(n)} + 1)					#part of the formula, 0 if no movies in common
	end
	def most_similar(user)
		return @users
		.map{|other_user_id, other_user| [other_user, similarity(user, other_user)]}			#iterates over all similar ones
		.reject{|other_user, similarity| similarity<=0}
		.sort_by{|other_user, similarity| -similarity}
		.map{|other_user,similarity| other_user}
	end
	def rating(user, movie)
		return user.get_movies[movie]
	end
	def predict(user, movie)						#predicts by filtering, arithmatic mean
		sum = 1
		return most_similar(user)
		.select{|other_user| rating(other_user, movie)}
		.reverse
		.map
		.with_index{|other_user, index|
			sum +=index
			rating(other_user,movie)*index
		}.inject(:+).to_f / sum
	end
	def movies(user)
		return user.get_movies
	end
	def viewers(movie)
		return movie.get_users
	end
	def run_test(s)								#computes test object
		s ||= @users_test.length
		subset = @users_test.first s.to_i
		return MovieTest.new(subset.map{|id, user| 
			user.get_movies
       			.map{|movie, rating|
				MovieResult.new(id, 
						movie.get_id, 
						rating.to_f,
						predict(retrieve_user(user),
							retrieve_movie(movie)))
			}
		}.flatten)
	end
	class MovieResult
		def initialize(user, movie, rating, prediction)
			@user = user
			@movie = movie
			@rating = rating
			@prediction = prediction
		end
		def error
			(@rating - @prediction).abs
		end
	end
	class MovieTest
		def initialize(source)
			@data = source
		end
		def to_a
			return @data
		end
		def length
			return @data.length
		end
		def mean
			return @data.map{|element|
				element.error}.reduce(:+).to_f / length.to_f
		end
		def stdev
			return sqrt(variance)
		end
		def variance
			mean_value = mean
			return @data.map{|element| 
				(element.error - mean_value)**2}.reduce(:+).to_f / length.to_f
		end
		def rms
			return sqrt(mean)
		end
	end
end
if ARGV.empty?
	puts 'usage: ./movie_data <ml-100k file location>[:{training data}] {-h|-load_data|-popularity movie_id|-popularity_list|-similarity user1 user2|-most_similar user}'
else	
	begin
		args = ARGV.shift.split(":")
		mv = MovieData.new(args.shift, args.shift)
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
			puts mv.popularity(ARGV.shift.to_i)
		when '-popularity_list'
			puts mv.popularity_list
		when '-similarity'
			puts mv.similarity(mv.get_user(ARGV.shift.to_i),mv.get_user(ARGV.shift.to_i))
		when '-most_similar'
			puts mv.most_similar(mv.get_user(ARGV.shift.to_i)).map{|user| user.get_id}
		when '-predict'
			puts mv.predict(mv.get_user(ARGV.shift.to_i), mv.get_movie(ARGV.shift.to_i))
		when '-test'
			mv = MovieData.new('ml-100k',:u1)
		when '-movies'
			puts mv.movies(mv.get_user(ARGV.shift.to_i))
		when '-viewers'
			puts mv.viewers(mv.get_movie(ARGV.shift.to_i))
		when '-run_test'
			puts mv.run_test(ARGV.shift)
		when '-mean'
			puts mv.run_test(ARGV.shift).mean
		when '-variance'
			puts mv.run_test(ARGV.shift).variance
		when '-stdev'
			puts mv.run_test(ARGV.shift).stdev
		else
			puts 'Invalid Command.'
		end
#	rescue
#		puts 'Bad or missing arguments'
	end
end


#mv = MovieData.new('ml-100k')
#puts mv.popularity_list
#puts mv.predict(1,6)
#puts mv.predict(1,1)
#puts mv.run_test(10)

#puts mv.similarity(305,6)
#puts mv.most_similar(305)
#puts mv.predict(305, 465)

