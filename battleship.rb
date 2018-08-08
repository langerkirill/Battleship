require_relative 'player'
require_relative 'board'
require_relative 'computerplayer'

class BattleshipGame

  SHIP_SYMS = {"Aircraft carrier" => :A, "Battleship" => :B,
  "Submarine" => :S, "Destroyer" => :D, "Patrol boat" => :P}

  attr_reader :player_one, :player_two, :board, :setup_board_one, :setup_board_two

  def initialize(player_one, player_two)
    @player_one = player_one
    @player_two = player_two
    @current_player = player_one
    setup
    if player_two
      unless @set_check
        @setup_board_one = Board.new
        @setup_board_two = Board.new
      end
    else
      @board = Board.new
    end
    play
  end

  def setup
    puts "Would you like to setup boards? (y/n)"
    answer = gets.chomp
    if answer == "y"
      @set_check = true
      board = Array.new(10) {Array.new(10, "wave")}
      board_two = Array.new(10) {Array.new(10, "wave")}
      setup_board_one = Board.new(board)
      setup_board_two = Board.new(board_two)
      @setup_board_one = setup_board_one
      @setup_board_two = setup_board_two
      until @setup_board_one.setup?
        place = @player_one.get_ship_placement(@setup_board_one)
        ship_and_size = @player_one.what_ship
        direction = @player_one.what_direction
        put_a_ship_there(place, ship_and_size, direction)
      end
      if @player_two.class == ComputerPlayer
        return @setup_board_two = Board.new
      end
      @player_two.restock_ships
      play_turn
      until @setup_board_two.setup?
        place = @player_two.get_ship_placement(@setup_board_two)
        ship_and_size = @player_two.what_ship
        direction = @player_two.what_direction
        put_a_ship_there(place, ship_and_size, direction)
      end
    end
  end

  def put_a_ship_there(place, ship_and_size, direction)
    if @current_player == player_one
      board = @setup_board_one
    else
      board = @setup_board_two
    end
      col = place[0]
      row = place[-1]
    begin
      if direction == "r" &&
         col + ship_and_size[-1] < 10 &&
         board.grid[row][col..(col+ship_and_size[-1])].none? {|spot| spot.class == Symbol}
         board.grid[row] = board.grid[row].map.with_index do |spot, j|
          if j >= col && j < col+ship_and_size[-1]
           SHIP_SYMS[ship_and_size[0]]
          else
            spot
          end
        end
      elsif direction == "d" &&
            row + ship_and_size[-1] < 10
            i = row
        while i < row + ship_and_size[-1]
          check = board.grid[i][col]
          raise_error if check != "wave"
          board.grid[i][col] = SHIP_SYMS[ship_and_size[0]]
          i += 1
        end
      end
      @current_player.delete_ship
    rescue
      puts "\nSomething went wrong, try again"
    end
  end

  def play
    until game_over?
      if @setup_board_one == nil
        board = @board
      elsif @current_player == player_one
        board = @setup_board_two
      elsif @current_player == player_two
        board = @setup_board_one
      end
      other_player
      puts "\n#{@current_player.name} has made #{17 - board.count_ships}/17 hits"
      @current_player.user_board_show
      move = @current_player.get_guess
      if board.ship?(move)
        ship = board.what_type_of_ship?(move)
        puts "\nYou hit #{@other_player.name}'s #{ship}!"
        boat = board.sunk?(ship)
        if boat != false
          puts "\nYou sunk #{@other_player.name}'s #{boat}!"
        end
        @current_player.user_board_change(move, true)
        attack(move)
      else
        puts "\n#{@current_player.name} missed!"
        @current_player.user_board_change(move, false)
        attack(move)
      end
      play_turn
    end
    play_turn
    puts "#{@current_player.name} wins!"
  end

  def other_player
    if @current_player == player_one
      @other_player = player_two
    elsif @current_player == player_two
      @other_player = player_one
    end
  end

  def attack(pos)
    if @setup_board_one == nil
      x = pos[0].to_i
      y = pos[-1].to_i
      @board.grid[x][y] = :x
    elsif @current_player == player_one
      x = pos[0].to_i
      y = pos[-1].to_i
      @setup_board_two.grid[x][y] = :x
    elsif @current_player == player_two
      x = pos[0].to_i
      y = pos[-1].to_i
      @setup_board_one.grid[x][y] = :x
    end
  end

  def count
    @board.count
  end

  def game_over?
    if @board == nil
      @setup_board_one.won? || @setup_board_two.won?
    elsif @setup_board_one == nil
      @board.won?
    end
  end

  def play_turn
    if @current_player == player_one
      @current_player = player_two
    else
      @current_player = player_one
    end
  end
end

game = BattleshipGame.new(HumanPlayer.new("Kirill"), HumanPlayer.new("Frank"))
game
