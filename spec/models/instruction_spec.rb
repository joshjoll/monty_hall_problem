require 'instruction'

RSpec.describe :instruction, type: :model do
    describe 'constant INSTRUCTION_LINES' do
        it 'returns a hash' do
            expect(Instruction::INSTRUCTION_LINES).to be_a(Hash)
        end
    end

    describe '.set_instructions' do
        it 'returns a string' do
            expect(Instruction.set_instructions).to be_a(String)            
        end
    end
end