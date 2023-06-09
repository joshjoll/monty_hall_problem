# README

## About
The Monty Hall problem explores statistics in the form of a game show, specifically modeled off of the game play of Let's Make a Deal. In this command line game, the contestant will be shown three doors; behind two of these doors are Goats, and behind the other is a Car. This game explores the paradox that it is statistically in the contestants best interest to change their pick. This concept is [explained more thoroughly here](https://en.wikipedia.org/wiki/Monty_Hall_problem).

## Game Play
The contestent will be given 2 guesses. After the first guess, the host will open one of the unpicked doors that has a Goat behind it. The contestant will then have the opportunity to choose either of the two remaining closed doors. If the contestant chooses correctly, they are awarded with a Car; Else, they will win a Goat.

**Steps to Play**
- All steps are to be ran from your terminal
- Navigate into the project directory.
- Load the `monty_hall.rb` file into a new IRB session by calling `irb -r ./monty_hall.rb`.
- Instantiate a new version of the game by calling `game = MontyHall.new()`. A set of instructions should be printed for you to follow
- To enter your first guess, run `game.first_guess(~your guess here~)`. All guesses should be in integer format, between 1 and 3
- After the host reveals a door, you can enter your second guess using `game.second_guess(~your guess here~)`
- To play again, run `game.play_again()`

## Exploring the Paradox
This game was built to help test the paradox that changing your guess after the door revealed is in your best interest. To easily test for yourself, you can use the MontyHall class method `iterate_games` to quickly run through a number of games and review the results.

The class method accepts 3 keyword arguments:
- `guess_one` is a required argument that is used as the first guess for each game iterated. It accepts an Integer.
- `iterations` is a required argument that is the total number of games that will be iterated. It accepts an Integer.
- `change_second_guess` is an optional argument that defaults to false. This value will be applied to each game, and will dictate whether the game will change its guess to the 'other' closed door during each iteration. It accepts a Boolean.

```
    MontyHall.iterate_games(guess_one: 2, iterations: 100, change_second_guess: true)
```

A hash is returned that shows the count of the iterations where a Car was won ('correct') against where a Goat was won ('incorrect')


## Set Up

This project was built using ruby version 3.0.0. 

