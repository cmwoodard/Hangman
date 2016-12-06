require 'colorize'
class Game
	attr_accessor :game_over_message, :game_over
	def initialize
		@the_word = self.new_word
		@game_over = false
		@visible_word = ""
		@guessed_this_turn = false
		@failed_guesses = 0
		@mr_hangman_array = ["    o ","\n   -","|","-","\n   /"," \\"]
		@mr_hangman = ""
		@guessed_letters = []
		(@the_word.length-1).times{@visible_word << "_"}
	end
	
	#returns a random new word between 5 and 12 characters, called for every new game automatically
	def new_word
		dictionary = File.open("5desk.txt", "r").readlines
		begin 
			@the_word = dictionary[rand(0..dictionary.length)]
		end while @the_word.length >= 12 || @the_word.length <=5
		@the_word
	end	
	
	#draws the board
	def draw_board
		#Clears screen - draws board
		system("cls")
		puts "    HANGMAN    \n\n\n".bold.red.on_white
		puts "----|\n    |\n"
		
		puts "#{@mr_hangman.red}\n\n"
		puts "          #{@visible_word}\n\n"
		puts "---------------\n #{@most_recent_guess}\n---------------\n"	
		print "\n#{@guessed_letters}\n\n"
	end
	
	def player_turn		
		@guessed_this_turn = false
		#Lets player guess
		puts "\nMake a guess, punk. (one letter)"
		guess = gets.chomp
		@guessed_letters.push(guess)
		self.compare_guess(guess)
				
		#just for display of most recent success/failure
		if @guessed_this_turn == true
			@most_recent_guess = "Ya got lucky..."
		else
			@most_recent_guess = "Wrong..."
			@failed_guesses+=1			
			@mr_hangman << @mr_hangman_array[@failed_guesses-1]
		end		
		
		#if we have any non letters
		if !@visible_word.include?("_")
			@game_over=true
			@game_over_message = "You are a winner!!!"
			self.draw_board
		end			
	end
	
	def check_turns
		if @failed_guesses==6
			@game_over=true
			@game_over_message = "You have lost!! Terrible!"
		end
	end
	
	def compare_guess(guess)	
		@the_word.length.times{|x|
		if @the_word[x-1].downcase == guess.downcase
			@visible_word[x-1] = guess
			@guessed_this_turn = true
		end		
		}		
	end
	
	def save?
		puts "Would you like to save this game?"
		save_answer = gets.chomp
		if save_answer.downcase == "y" || save_answer.downcase == "yes"
			puts "What do you want to name your save?"
			save_game(gets.chomp)
		end
		self.draw_board	
	end
	
	def save_game(save_name)
		save = "#{save_name}.txt"
		save_file = File.open(save, "w")
		save_file.puts @the_word
		save_file.puts @visible_word
		save_file.puts @failed_guesses
		save_file.puts @guessed_letters
		save_file.close
		puts "Game state saved..."
	end
	
	def load_game(file_name)
		file = File.open("#{file_name}.txt", "r")
		@the_word = file.readline
		@visible_word = file.readline
		@failed_guesses = file.readline.to_i
		while !file.eof?
			@guessed_letters.push(file.readline.chomp)
		end
		
		@failed_guesses.times{|x| @mr_hangman << @mr_hangman_array[x] }
		puts "#{@the_word},#{@visible_word},#{@failed_guesses},#{@guessed_letters}"
		gets
	end
end

game = Game.new

#Ask to load game
puts "Would you like to load a game?"
save_answer = gets.chomp
if save_answer.downcase == "y" || save_answer.downcase == "yes"
	puts "What is the name of your save?"
	game.load_game(gets.chomp)
end

#Main game loop
while game.game_over == false	
	game.draw_board	
	game.player_turn
	game.check_turns
	game.draw_board
	game.save?	
end
game.draw_board
puts "\n#{game.game_over_message}"
gets