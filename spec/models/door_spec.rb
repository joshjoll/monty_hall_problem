require 'door'

RSpec.describe Door, type: :model do

    it "builds a new door with default state" do
        door = build(:door)

        expect(door.door_number).to eq(1)
        expect(door.state).to eq('Closed')
        expect(door.behind).to eq('Goat')
    end
    
    describe '#has_a_car' do
        it 'changes the prize to a car' do
            door = build(:door)            
            expect(door.behind).to eq('Goat')

            door.has_a_car
            expect(door.behind).to eq('Car')
        end
    end

    describe '#open_door' do
        it 'opens the door' do
            door = build(:door)
            expect(door.state).to eq('Closed')

            door.open_door
            expect(door.state).to eq('Open')
        end
    end
end