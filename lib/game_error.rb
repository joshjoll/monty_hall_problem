module Error
    class GameError < StandardError
        attr_reader :object, :message
    
        def initialize(object, message)
            @object = object
            @message = message
        end
    end

    class InelligibleGuess < GameError
        def initialize(message)
            super(InelligibleGuess, message)
        end
    end

    class IncorrectOrder < GameError
        def initialize(message)
            super(IncorrectOrder, message)
        end
    end
end