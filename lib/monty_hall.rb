require_relative "Game"
require_relative "game_error"

class MontyHall
    attr_accessor :game


    def self.iterate_games(guess_one: , change_second_guess: false, iterations: )
        results = { "correct" => 0, "incorrect" => 0 }

        puts "Changing the answer on the second guess: #{change_second_guess}"

        iterations.times do |index|
            game = Game.new(show_instructions: false, show_prompts: false)

            game.set_first_guess(guess_one)
            
            second_guess = game.change_input_for_guess_two(change_second_guess)
            result = game.set_second_guess(second_guess)
            
            puts "Game #{index + 1}: #{result}"
            results[result] += 1
        end
        return results
    end

    def initialize(show_instructions: true, show_prompts: true)
        @game = Game.new(show_instructions: show_instructions, show_prompts: show_prompts)
    end 

    def first_guess
        loop do
            guess_one = gets.chomp.to_i
            begin
                return @game.set_first_guess(guess_one) 
            rescue Error::GameError => e
                puts e.message
            end
        end
    end

    def second_guess
        loop do
            guess_two = gets.chomp.to_i
            begin
                return @game.set_second_guess(guess_two)
            rescue Error::GameError => e
                puts e.message
            end
        end
    end

    def play_again()
        # get the previous game's animations value
        animations = @game.animations
        @game = Game.new()
    end

    def instructions
        puts @game.instructions()
    end

    alias_method  'help', 'instructions'
end
