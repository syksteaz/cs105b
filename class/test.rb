class Greeter
	def initialize(name)
		@the_name = name
	end

end

g = Greeter.new("Aaron")

puts g.the_name