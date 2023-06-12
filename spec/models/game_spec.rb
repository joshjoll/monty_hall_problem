require 'game'
require 'game_error'
require 'stringio'

RSpec.describe :game, type: :model do

    describe '#initialize' do
        context "with all logs" do
            it 'logs the instructions' do
                output = StringIO.new 
                game2 = Game.new(output: output)
    
                expect(output.string).to include(Instruction.set_instructions)
            end
            
            it 'prompts the user to input a first guess' do
                output = StringIO.new 
                game2 = Game.new(output: output)
                
                expect(output.string).to include('Which door would you like to select with your first guess? Please input 1, 2, or 3 as an integer?')
            end
        end
        
        context 'with prompts but no instructions' do
            it "does not show the instructions" do
                output = StringIO.new 
                game2 = Game.new(show_instructions: false, output: output)
        
                expect(output.string).not_to include(Instruction.set_instructions)
            end
            it "logs the first prompt" do
                output = StringIO.new 
                game2 = Game.new(output: output)
        
                expect(output.string).to include('Which door would you like to select with your first guess? Please input 1, 2, or 3 as an integer?')
            end
        end

        context 'without prompts or instructions' do
            it "does not show the instructions" do
                output = StringIO.new 
                game2 = Game.new(show_instructions: false, show_prompts: false, output: output)
        
                expect(output.string).not_to include(Instruction.set_instructions)
            end
            it "does not log the first prompt" do
                output = StringIO.new 
                game2 = Game.new(show_instructions: false, show_prompts: false, output: output)
        
                expect(output.string).not_to include('Which door would you like to select with your first guess? Please input 1, 2, or 3 as an integer?')
            end
        end
    end

    describe '#set_first_guess' do
        context 'passed an invalid argument' do
            context "a non-integer value" do
                it "raises an error" do
                    game = Game.new(show_instructions: false, show_prompts: false)
                    expect{game.set_first_guess('1')}.to raise_error(Error::InelligibleGuess)
                end
            end

            context "an invalid door value" do
                it "raises an error" do
                    game = Game.new(show_instructions: false, show_prompts: false)
                    expect{game.set_first_guess(4)}.to raise_error(Error::InelligibleGuess)
                end
            end
        end
        it 'raises an error if guessed a second time' do
            game = Game.new(show_instructions: false, show_prompts: false)
            expect{game.set_first_guess(1)}.not_to raise_error
            
            expect{game.set_first_guess(1)}.to raise_error(Error::IncorrectOrder)
        end

        it 'reveals a goat' do
            output = StringIO.new
            game = Game.new(show_instructions: false, show_prompts: true, output: output)

            first_guess = 1
            game.set_first_guess(first_guess)
            expect(output.string).to include("has been opened, and shows you a Goat. Please enter either your current selection (door #{first_guess}) or change to door")
        end
    end

    describe '#set_second_guess' do
        it 'raises an error if first guess is not already made' do
            game = Game.new(show_instructions: false, show_prompts: false)
            
            expect{game.set_second_guess(1)}.to raise_error(Error::IncorrectOrder)
        end

        context 'passed an invalid argument' do
            context "a non-integer value" do
                it "raises an error" do
                    game = Game.new(show_instructions: false, show_prompts: false)
                    game.set_first_guess(1)
                    expect{game.set_second_guess('1')}.to raise_error(Error::InelligibleGuess)
                end
            end
            
            context "an invalid door value" do
                it "raises an error" do
                    game = Game.new(show_instructions: false, show_prompts: false)
                    game.set_first_guess(1)
                    expect{game.set_second_guess(4)}.to raise_error(Error::InelligibleGuess)
                end
            end
        end

        it 'reveals door with a car' do
            output = StringIO.new
            game = Game.new(show_instructions: false, show_prompts: true, output: output)

            game.set_first_guess(1)

            game.set_second_guess(1)
            expect(output.string).to include("The car was behind door number")
        end
    end
end