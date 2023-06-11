require_relative "door"
require_relative 'game_error'
class Game
    attr_accessor :animations

    def initialize(use_animations: true)
        @doors = []

        @guess_one = nil
        @guess_two = nil
        @animations = use_animations

        set_game()
        instructions() if @animations

    end

    def instructions
        puts set_instructions()
    end

    def set_first_guess(door)
        raise Error::InelligibleGuess.new('You have already taken a first guess. Please use the `second_guess(`your guess here`)` method to continue playing') unless @guess_one.nil?

        raise Error::InelligibleGuess.new('Please guess either 1, 2, or 3 as an integer') unless (1..3).include?(door)
        
        @guess_one = door

        game_delay() if @animations
        reveal_a_goat()
    end

    def set_second_guess(door)
        raise Error::IncorrectOrder.new('Please use the `first_guess` method to make your first guess')  if @guess_one.nil?

        raise Error::InelligibleGuess.new('You have already taken a second guess. The game is over; Please play again by instantiating a new instance of the game') unless @guess_two.nil?

        closed_doors = get_closed_doors.map(&:door_number)

        raise Error::InelligibleGuess.new("Please guess either #{ closed_doors.join(' or ') } as an integer") unless closed_doors.include?(door)

        @guess_two = door

        game_delay() if @animations
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

        puts "Door number #{door_to_reveal.door_number} has been opened, and shows you a Goat. Please enter either your current selection (door #{@guess_one}) or change to door #{other_door.door_number} as an integer. \n" if @animations
    end
    
    def resolve_game()
        car_door = @doors.find{|d| d.behind == "Car"}
        if car_door.door_number == @guess_two
            puts "Congratulations on your new car! The car was behind door number #{car_door.door_number}. Please play again!" if @animations
            return 'correct'
        else
            puts "Congratulations on your new goat! The car was behind door number #{car_door.door_number}. Please try again!" if @animations
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
        sleep(0.5)
        puts '...'
        sleep(0.5)
        puts '...'
        sleep(0.5)
        puts '...'
        sleep(0.5)
    end

    def set_instructions
        line_1 = "Welcome to the Monty Hall Game, where you can explore the Monty Hall problem."
        line_2 = "There are three doors. Behind two doors are Goats, and behind the other door is a new Car."
        line_3 = "You will get two guesses. After your first guess, I will reveal one of the unselected doors. This door will have a Goat behind it."
        line_4 = "You will then get the choice to either change your guess or stick with your original pick."
        line_5 = "You will then be showed your prize and which door held the Car."
        line_6 = ""
        line_7 = "Which door would you like to select with your first guess? Please input 1, 2, or 3 as an integer"
        return [line_1, line_2, line_3, line_4, line_5, line_6, line_7].join("\n")
    end

end