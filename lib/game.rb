require_relative "door"
require_relative 'game_error'
require_relative 'instruction'

class Game
    attr_accessor :use_animations, :show_prompts

    def initialize(show_instructions: true, show_prompts: true, output: $stdout)
        @output = output

        @doors = []
        @guess_one = nil
        @guess_two = nil
        @use_animations = show_instructions
        @show_prompts = show_prompts

        instructions() if @use_animations
        set_game()

    end

    def instructions
        @output.puts Instruction.set_instructions()
    end

    def set_first_guess(door)
        raise Error::IncorrectOrder.new('You have already taken a first guess. Please use the `second_guess(`your guess here`)` method to continue playing') unless @guess_one.nil?

        raise Error::InelligibleGuess.new('Please guess either 1, 2, or 3 as an integer') unless (1..3).include?(door)
        
        @guess_one = door

        game_delay() if @use_animations
        reveal_a_goat()
    end

    def set_second_guess(door)
        raise Error::IncorrectOrder.new('Please use the `first_guess` method to make your first guess')  if @guess_one.nil?

        raise Error::InelligibleGuess.new('You have already taken a second guess. The game is over; Please play again by instantiating a new instance of the game') unless @guess_two.nil?

        closed_doors = get_closed_doors.map(&:door_number)

        raise Error::InelligibleGuess.new("Please guess either #{ closed_doors.join(' or ') } as an integer") unless closed_doors.include?(door)

        @guess_two = door

        game_delay() if @use_animations
        resolve_game()
    end 

    ### when iterating through the class method, this will dynamically change the second guess to the other closed door
    def change_input_for_guess_two(change_second_guess)
        return @guess_one unless change_second_guess

        return @doors.find{|door| door.door_number != @guess_one && door.state == 'Closed'}.door_number
    end
    
private

    # Game Logic
    ## Setup
    def set_game
        create_doors()
        set_door_with_car()

        @output.puts "\nWhich door would you like to select with your first guess? Please input 1, 2, or 3 as an integer?" if @show_prompts
    end
    
    def create_doors
        3.times do |i|
            @doors.append(Door.new(i+1))
        end
    end

    def set_door_with_car
        random_door = rand(1..3)
        @doors.find{|d| d.door_number == random_door}.has_a_car
    end

    
    ## Game Play
    def reveal_a_goat
        doors_with_goats = get_goats()
        if doors_with_goats.map(&:door_number).include?(@guess_one)
            door_to_reveal = doors_with_goats.find{|d| d.door_number != @guess_one} #door that is not guessed
        else
            door_to_reveal= doors_with_goats.sample
        end

        door_to_reveal.open_door
        other_door = @doors.find{|d| d.state == 'Closed' && d.door_number != @guess_one}

        @output.puts "Door number #{door_to_reveal.door_number} has been opened, and shows you a Goat. Please enter either your current selection (door #{@guess_one}) or change to door #{other_door.door_number} as an integer. \n" if @show_prompts
    end
    
    def resolve_game()
        car_door = @doors.find{|d| d.behind == "Car"}
        if car_door.door_number == @guess_two
            @output.puts "Congratulations on your new car! The car was behind door number #{car_door.door_number}. Please play again!" if @show_prompts
            return 'correct'
        else
            @output.puts "Congratulations on your new goat! The car was behind door number #{car_door.door_number}. Please try again!" if @show_prompts
            return 'incorrect'
        end
    end
    
    # Query Helpers
    def get_goats
        @doors.select{|door| door.behind == 'Goat'}
    end

    def get_closed_doors
        @doors.select{|door| door.state == 'Closed'}
    end

    # Game Helpers
    def game_delay
        3.times do
            sleep(0.5)
            @output.puts '...'
        end
    end
end