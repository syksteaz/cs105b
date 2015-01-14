#!/usr/bin/env ruby
#Eden Zik
#MovieData processor program

#Use: ./movie_data.rb [location of ml-100k directory]


class MovieData
	def initialize(breed, name)  
		# Instance variables  
		@movie_rating = Hash.new()
		@person_movies_rating = Hash.new()
	end  
	def load_data(filename)	#Reads all rating data 
		open(filename) do |lines|
			lines.each_line do |line|
				process_movie_rating(line)
				process_person_movies_rating(line)
			end
		end
	end
	def process_person_movies_rating(line)
		splitLine = line.split("\t")
		if @person_movies_rating[splitLine[0]].nil?
			@person_movies_rating[splitLine[0]] = Hash.new()
		end
		@person_movies_rating[splitLine[0]][splitLine[1]] = splitLine[2]
	end
	def process_movie_rating(line)
		splitLine = line.split("\t")
		oldRatingPair = @movie_rating[splitLine[1]]
		oldRating = 0
		oldNumRaters = 0
		if oldRatingPair.nil? == false
			oldRating = oldRatingPair[0]
			oldNumRaters = oldRatingPair[1]
		end
		@movie_rating[splitLine[1].to_i] = [oldRating + splitLine[2].to_i, oldNumRaters+1]
	end
	def get_popularity(movie_id)
		ratingValueNumRatersPair = @movie_rating[movie_id]
		if ratingValueNumRatersPair.nil? == false
			return ratingValueNumRatersPair[0].to_f/ratingValueNumRatersPair[1].to_f
		end
	end
	def popular_list()
		lala = []
		@movie_rating.each do |key, value|
			lala = lala << get_popularity(key)
		end
		return lala
	end
	def getStuff()
		return @person_movies_rating
	end
end

movies = Hash.new()


#command = ARGV.first

#puts MovieData.load_data("example.txt")

#puts command == "hello"

mv = MovieData.new('Labrador', 'Benzy')  

mv.load_data("/Users/edenzik/OLD/cosi105b/PA01/ml-100k/u.data")

#puts mv.getStuff

#puts mv.get_popularity(24134)

puts mv.popular_list()
#puts ratings.sort_by {|k, v| v}













