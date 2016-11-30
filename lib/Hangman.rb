class Game
	attr_accessor :the_word
	def initialize
		@the_word = self.new_word
	end
	
	def new_word
		dictionary = File.open("5desk.txt", "r").readlines
		begin 
			@the_word = dictionary[rand(0..dictionary.length)]
		end while @the_word.length >= 12 || @the_word.length <=5
		@the_word
	end
	
end

game = Game.new
puts game.the_word.length
