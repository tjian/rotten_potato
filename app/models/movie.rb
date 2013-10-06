class Movie < ActiveRecord::Base
	def self.ratings
		ratings = []
		Movie.all.each do |movie|
			ratings << movie.rating if not ratings.include? movie.rating
		end
		ratings
	end
end
