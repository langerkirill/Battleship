class HumanPlayer

  SHIPS = {"Aircraft carrier" => 5, "Battleship" => 4,
  "Submarine" => 3, "Destroyer" => 3, "Patrol boat" => 2}

  attr_reader :name

  def initialize(name)
    @name = name
    @user_board = Array.new(10) {Array.new(10, "wave")}
  end

  def get_guess
    puts "\n\nIt's your turn, #{self.name}"
    puts "\nEnter an attack. Use x, y coordinates (e.g. B, 1 etc.):"
    move = move_translate(gets.chomp)
  end

  def get_ship_placement(board)
    puts "\nHere is your board #{self.name}:"
    puts "\n"
    display(board)
    puts "\n\nHere are the ships and their lengths:"
    puts SHIPS
    puts "\n\nWhere would you like to place your ship? (e.g. B, 1 etc.)"
    puts "You can place them down from the spot or right from the spot"
    spot = gets.chomp
    move_translate(spot)
  end

  def display(board)
    i = 9
    board.grid.each do |row|
      print "#{i}  #{row} \n"
      i -= 1
    end
    10.times do |j|
      j = ("A".."J").to_a[j]
      print "      #{j} "
    end
  end

  def what_ship
    puts "What ship do you want to place there?"
    @ship = gets.chomp.capitalize
    size = SHIPS[@ship]
    [@ship.capitalize, size]
  end

  def delete_ship
    SHIPS.delete(@ship)
  end

  def restock_ships
    SHIPS.replace({"Aircraft carrier" => 5, "Battleship" => 4,
    "Submarine" => 3, "Destroyer" => 3, "Patrol boat" => 2})
  end

  def what_direction
    puts "Down from the spot or to the right? (e.g. d or r)"
    gets.chomp
  end

  def user_board_change(pos, hit)
      y = pos[0].to_i
      x = pos[-1].to_i
    if hit
      @user_board[x][y] = "!!!!"
    else
      @user_board[x][y] = "miss"
    end
  end

  def move_translate(pos)
    y = ("A".."J").to_a.index(pos[0].upcase)
    x = 9 - pos[-1].to_i
    [y,x]
  end

  def user_board_show
    i = 9
    puts "\n#{self.name}'s board:"
    puts "\n"
    @user_board.each do |row|
      print "#{i}  #{row} \n"
      i -= 1
    end
    10.times do |j|
      j = ("A".."J").to_a[j]
      print "      #{j} "
    end
  end
end
