require_relative 'board.rb'

class Game
    attr_reader :board
    def initialize
        @level = get_level
        @board = Board.new(@level)
    end

    def get_level
        puts "1. Easy"
        puts "2. Average"
        puts "3. Hard"
        puts "Choose your level (example : for Easy type 1) "
        print "> "
        case gets.chomp.to_i
        when 1
            return "easy"
        when 2
            return "average"
        when 3
            return "hard"
        else
            puts "Set to default level"
            return "easy"
        end
    end

    def run
        system("clear")
        @board.place_random_bombs
        @board.update_neighbour_bombs_count
        play_turn until game_over?
    end

    def play_turn
        system("clear")
        board.cheat
        board.render
        pos = get_pos
        val = get_val
        update_board(pos,val)
    end

    def get_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts "Please enter a position on the board (e.g., '3,4')"
            print "> "
            pos = parse_pos(gets.chomp)
        end
    pos
    end

    def get_val
        val = nil
        until val && valid_val?(val)
            puts "Choose your action"
            puts "F : Flag"
            puts "R : Reveal"
            puts "X : Remove Flag"
            print "> "
            val = gets.chomp.downcase
        end
        val
    end

    def valid_pos?(pos)
        pos.is_a?(Array) &&
          pos.length == 2 &&
          pos[0].between?(0,@board.height-1) && pos[1].between?(0,@board.width-1)
    end
    
    def valid_val?(val)
        val == 'f' || val == 'r' || val == 'x'
    end
    
    def parse_pos(string)
        string.split(",").map { |char| Integer(char) }
    end
    
    def game_over?
        if @board.destroyed?
            puts "Oop! You landed a mine"
            puts "Game Over"
            true
        elsif @board.cleared?
            puts "Congratulation!"
            puts "You Win"
            true
        else
            false
        end
    end

    def update_board(pos,val)
        case val
        when 'f'
            @board[pos].flag
        when 'r'
            @board[pos].reveal
            #reveal_adjacents(pos)
        when 'x'
            @board[pos].unflag
        end
    end

end

if $PROGRAM_NAME == __FILE__
    game = Game.new
    game.run
end