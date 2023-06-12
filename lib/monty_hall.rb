require_relative "Game"
require_relative "game_error"

class MontyHall
    attr_accessor :game


    def self.iterate_games(guess_one: , change_second_guess: false, iterations: , show_output: true)
        results = { "correct" => 0, "incorrect" => 0 }

        puts "Changing the answer on the second guess: #{change_second_guess}" if show_output

        iterations.times do |index|
            game = Game.new(show_instructions: false, show_prompts: false)

            game.set_first_guess(guess_one)
            
            second_guess = game.change_input_for_guess_two(change_second_guess)
            result = game.set_second_guess(second_guess)
            
            puts "Game #{index + 1}: #{result}" if show_output
            results[result] += 1
        end
        return results
    end

    def initialize(show_instructions: true, show_prompts: true, output: $stdout, input: $stdin)
        @output = output
        @input = input
        @game = Game.new(show_instructions: show_instructions, show_prompts: show_prompts, output: output)
    end 

    def first_guess
        loop do
            guess_one = @input.gets.to_i
            begin
                return @game.set_first_guess(guess_one) 
            rescue Error::GameError => e
                @output.puts e.object
                @output.puts e.message
            end
        end
    end

    def second_guess
        loop do
            guess_two = @input.gets.to_i
            begin
                return @game.set_second_guess(guess_two)
            rescue Error::GameError => e
                @output.puts e.object
                @output.puts e.message
            end
        end
    end

    def play_again()
        # get the previous game's animations value
        animations = @game.use_animations
        show_prompts = @game.show_prompts
        @game = Game.new(show_instructions: animations, show_prompts: show_prompts, output: @output)
    end

    def instructions
        @output.puts Instruction.set_instructions()
    end

    alias_method  'help', 'instructions'
end
