#!/usr/bin/env ruby
require_relative 'monty_hall' 
new_game = true
while new_game == true do
    game = MontyHall.new()

    game.first_guess()

    game.second_guess()

    print "Would you like to play again? [Y/N]"
    play_again = gets.chomp
    if ["Y", "Yes", "y", "yes"].include?(play_again)
        new_game = true
    else
        print "Thanks for playing!"
        new_game = false
    end
end
