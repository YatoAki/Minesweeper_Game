require_relative 'tile.rb'
class Board
    attr_reader :grid,:height,:width,:bombs
    def initialize(level)
        if level == "easy"
            @height = 9
            @width = 9
            @bombs = 10
        elsif level == "average"
            @height = 16
            @width = 16
            @bombs = 40
        elsif level == "hard"
            @height = 16
            @width = 30
            @bombs = 99
        end
        @grid = Array.new(height){Array.new(width){Tile.new}}
    end

    def num_bombs
        @grid.flatten.count{|ele| ele.explode?}
    end

    def place_random_bombs
        while num_bombs < @bombs
            position = [rand(0...height),rand(0...width)]
            self[position] = Tile.new(true)
        end
    end

    def [](pos)
        x,y = pos
        @grid[x][y]
    end

    def []=(pos,value)
        x,y = pos
        @grid[x][y] = value
    end

    def render
        @grid.each do |row|
            puts row.join(" ")
        end
    end

    def cheat
        @grid.each do |row|
            row.each do |ele|
                if ele.explode?
                    print " X "
                elsif ele.revealed
                    print " _ "
                elsif ele.flagged
                    print " F "
                else
                    print " * "
                end
            end
            puts
        end
    end
end

if $PROGRAM_NAME == __FILE__
    board = Board.new("easy")
    board.place_random_bombs
    puts "cheat & render"
    board.cheat
    puts
    board.render
    board[[1,2]].flag
    board[[1,3]].reveal
    puts "cheat & render"
    board.cheat
    puts
    board.render
end