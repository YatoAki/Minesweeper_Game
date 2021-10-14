require_relative 'tile.rb'
require 'byebug'
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
        elsif level == "test"
            @height = 6
            @width = 10
            @bombs = 9
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
        puts "  #{(0...@width).to_a.join(" ")}"
        @grid.each_with_index do |row,i|
            puts "#{i} #{row.join(" ")}"
        end
    end

    def cheat
        puts " #{(0...@width).to_a.join("  ")}"
        @grid.each_with_index do |row,i|
            row.each do |ele|
                if ele.explode?
                    print " X "
                elsif ele.revealed
                    print " _ "
                elsif ele.flagged
                    print " F "
                else
                    print " #{ele.neighbour_bombs_count} "
                end
            end
            puts
        end
    end

    def valid_pos?(pos)
        row, column = pos
        row.between?(0,@height-1) && column.between?(0,@width-1)
    end

    def neighbour(i,j)
        tiles = []
        row = i - 1
        column = j - 1
        (row...(row+3)).each do |idx1|
            (column...(column+3)).each do |idx2|
                pos = [idx1,idx2]
                tiles << self[pos] if valid_pos?(pos)
            end
        end
        tiles
    end

    def bombs_count(area)
        area.count{|ele| ele.explode?}
    end
    
    def update_neighbour_bombs_count
        @grid.each_with_index do |row,i|
            row.each_with_index do |tile,j|
                area = neighbour(i,j)
                tile.neighbour_bombs_count = bombs_count(area)
            end
        end
    end

    def reveal_adjacents(pos)
        row,column = pos
        area = neighbour(row,column)
        area.each do |tile|
            tile.reveal if tile.neighbour_bombs_count == 0
        end
    end

    def destroyed?
        @grid.each do |rows|
            return true if rows.any? {|tile| tile.bombed && tile.revealed}
        end
        return false
    end

    def cleared?
        @grid.all? do |rows|
            true if rows.all? {|tile| (tile.bombed && tile.flagged) || (tile.bombed == false)}
        end
    end
end

if $PROGRAM_NAME == __FILE__
    board = Board.new("easy")
    board.place_random_bombs
    board.cheat
    #debugger
    board.update_neighbour_bombs_count
    puts
    board.cheat
    board.render
end