require 'colorize'

class Tile
    attr_accessor :bombed,:flagged,:revealed,:neighbour_bombs_count
    def initialize(bombed = false)
        @bombed = bombed
        @flagged  = false
        @revealed = false
        @neighbour_bombs_count = 0
    end

    def reveal
        @revealed = true
    end

    def to_s
        return "F".colorize(:red) if @flagged
        out = @neighbour_bombs_count > 0 ? @neighbour_bombs_count.to_s : "_"
        @revealed ? out : "*"
    end

    def flag
        @flagged = true
    end

    def unflag
        @flagged = false
    end

    def explode?
        @bombed
    end
end
