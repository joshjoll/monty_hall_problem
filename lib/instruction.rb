class Instruction

    INSTRUCTION_LINES = {
            'line_1' => "Welcome to the Monty Hall Game, where you can explore the Monty Hall problem.",
            'line_2' => "There are three doors. Behind two doors are Goats, and behind the other door is a new Car.",
            'line_3' => "You will get two guesses. After your first guess, I will reveal one of the unselected doors. This door will have a Goat behind it.",
            'line_4' => "You will then get the choice to either change your guess or stick with your original pick.",
            'line_5' => "You will then be showed your prize and which door held the Car.",
            'line_6' => ""
        }

    def self.set_instructions
        INSTRUCTION_LINES.values.join("\n")
    end

end