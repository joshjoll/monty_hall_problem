module Error
    class GameError < StandardError
        attr_reader :object, :message
    
        def initialize(object, message)
            @object = object
            @message = message
        end
    end
end