require 'colorize'

class Tile
    attr_accessor :flagged,:revealed
    def initialize(bombed = false)
        @bombed = bombed
        @flagged  = false
        @revealed = false
    end

    def reveal
        @revealed = true
    end

    def to_s
        return "F".colorize(:red) if @flagged
        @revealed ? "_" : "*"
    end

    def flag
        @flagged = true
    end

    def explode?
        @bombed
    end
end
