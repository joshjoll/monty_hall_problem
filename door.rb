class Door
    attr_reader :behind, :state, :door_number

    def initialize(door_number)
      @behind = 'Goat'
      @state = 'Closed'
      @door_number = door_number
    end

    def door_number
        @door_number
    end

    def has_a_car
        @behind = 'Car'
    end

    def open_door
        @state = 'Open'
    end
end