require 'monty_hall'
require 'stringio'

RSpec.describe 'monty_hall', type: :model do
    describe '.iterate_games' do
        it 'returns a hash' do
            iterator = MontyHall.iterate_games(guess_one: 1, iterations: 10, show_output: false)
            expect(iterator).to be_a(Hash)
        end

        it "accurately stores the results of the game iterations" do
            iterations = 10
            iterator = MontyHall.iterate_games(guess_one: 1, iterations: iterations, show_output: false)
            expect(iterator.values.sum()).to eq(iterations)
            expect(iterator.values.sum()).not_to eq(iterations + 1)
        end

        it "returns the incorrect and correct guess totals" do
            iterator = MontyHall.iterate_games(guess_one: 1, iterations: 10, show_output: false)
            expect(iterator).to have_key('correct')
            expect(iterator).to have_key('incorrect')
            expect(iterator.keys.count).to eq(2)
        end
                
    end

    describe '#first_guess' do
        context "with valid input" do
            it 'asks for input only once' do
                first_guess = '1'
                input = StringIO.new(first_guess)
                output = StringIO.new()
                monty = MontyHall.new(show_instructions: false, show_prompts: true, input: input, output: output)

                monty.first_guess
                expect(output.string).to include("has been opened, and shows you a Goat. Please enter either your current selection (door #{first_guess}) or change to door")

            end
        end

        context "with invalid input" do
            context "when passed a alpha numeric string" do
                it "asks for the input until an integer is provided" do
                    valid_guess = 1
                    input = StringIO.new("'one'\n'number one'\n#{valid_guess}")
                    output = StringIO.new()

                    monty = MontyHall.new(show_instructions: false, show_prompts: true, input: input, output: output)
                    monty.first_guess

                    expect(output.string.scan('Error::InelligibleGuess').size).to eq(2)
                    expect(output.string).to include("has been opened, and shows you a Goat. Please enter either your current selection (door #{valid_guess}) or change to door")
                end
            end
        end
    end

    describe '#second_guess' do
        context "with valid input" do
            it 'asks for input only once' do
                guess = '1'
                input = StringIO.new("#{guess}\n#{guess}")
                output = StringIO.new()
                monty = MontyHall.new(show_instructions: false, show_prompts: true, input: input, output: output)

                monty.first_guess
                monty.second_guess
                expect(output.string).to include("! The car was behind door number")

            end
        end

        context "with invalid input" do
            context "when passed a character string" do
                it "asks for the input until an integer is provided" do
                    valid_guess = 1
                    input = StringIO.new("#{valid_guess}\n'one'\n'number one'\n#{valid_guess}")
                    output = StringIO.new()

                    monty = MontyHall.new(show_instructions: false, show_prompts: true, input: input, output: output)
                    monty.first_guess
                    monty.second_guess

                    expect(output.string.scan('Error::InelligibleGuess').size).to eq(2)
                    expect(output.string).to include("! The car was behind door number")
                end
            end
        end
    end

    describe '#play_again' do
        it 'creates a new instance of the game' do
            monty = MontyHall.new(show_instructions: false, show_prompts: false)
            game = monty.game
            monty.play_again()

            game2 = monty.game
            expect(game).not_to eq(game2)
        end

        context "using all logs" do
            it 'conveys the log arguments to the new game instance' do
                output = StringIO.new
                monty = MontyHall.new(show_instructions: true, show_prompts: true, output: output)
                game = monty.game

                monty.play_again()
                game2 = monty.game

                expect(output.string.scan(Instruction.set_instructions).size).to eq(2)
                puts output.string
            end
        end

        context "without using logs" do
            it 'does not convey log arguments to the new game instance' do
                output = StringIO.new
                monty = MontyHall.new(show_instructions: false, show_prompts: false, output: output)
                game = monty.game
                
                monty.play_again()
                expect(output.string).not_to include(Instruction.set_instructions)
                
            end
        end
    end

    describe 'instructions' do
        it 'returns the game play instructions' do
            output = StringIO.new
            monty = MontyHall.new(show_instructions: false, show_prompts: false, output: output)
            monty.instructions
            expect(output.string).to include(Instruction.set_instructions)
        end

        it 'responds to the alias help' do
            output = StringIO.new
            monty = MontyHall.new(show_instructions: false, show_prompts: false, output: output)
            monty.help
            expect(output.string).to include(Instruction.set_instructions)
        end
    end
end