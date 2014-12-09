module MovieRatingProcessor
	def MovieRatingProcessor.load_ratings(filename)
		ratings = Hash.new()
		file = open(filename) do |lines|
			lines.each_line do |line|
				splitLine = line.split("\t")
				oldRatingPair = ratings[splitLine[1]]
				oldRating = 0
				oldNumRaters = 0
				if oldRatingPair.nil? == false
					oldRating = oldRatingPair[0]
					oldNumRaters = oldRatingPair[1]
				end
				ratings[splitLine[1].to_i] = [oldRating + splitLine[2].to_i, oldNumRaters+1]
			end
		end
		return ratings
	end

	def MovieRatingProcessor.get_rating(movie_id, ratings)
		ratingValueNumRatersPair = ratings[movie_id]
		if ratingValueNumRatersPair.nil? == false
			return ratingValueNumRatersPair[0].to_f/ratingValueNumRatersPair[1].to_f
		end
	end
end

movies = Hash.new()

movies["m"] = "hello"


command = ARGV.first

#puts MovieData.load_data("example.txt")

puts command == "hello"

puts movies["m"]

ratings = MovieRatingProcessor.load_ratings("/Users/edenzik/ml-100k/u.data")

puts ratings

puts MovieRatingProcessor.get_rating(543243, ratings)











