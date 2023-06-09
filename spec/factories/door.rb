FactoryBot.define do
    factory :door do
        behind { 'Goat' }
        state { 'Closed' }
        door_number { 1 }
    end
end