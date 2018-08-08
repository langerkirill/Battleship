class Board
  attr_reader :grid

  SHIPS = {"Aircraft carrier" => 5, "Battleship" => 4,
  "Submarine" => 3, "Destroyer" => 3, "Patrol boat" => 2}

  SHIP_SYMS = {"Aircraft carrier" => :A, "Battleship" => :B,
  "Submarine" => :S, "Destroyer" => :D, "Patrol boat" => :P}

  def initialize(grid = nil)
    @hit_record = []
    if grid == nil
      @grid = Board.default_grid
      distribute_ships
    else
      @grid = grid
    end
  end

  def self.default_grid
    @grid = Array.new(10) {Array.new(10)}
  end

  def what_type_of_ship?(move)
    x = move[0].to_i
    y = move[-1].to_i
    ship = SHIP_SYMS.key(@grid[x][y])
    ship
  end

  def sunk?(ship)
    @hit_record << ship
    SHIPS.keys.each do |boat|
      if @hit_record.count(ship) == SHIPS[boat] && ship == boat
        @hit_record.delete(ship)
        return ship
      end
    end
    false
  end

  def count_ships
    return 0 if @grid.all? {|row| row.compact == []}
    ships = 0
    SHIP_SYMS.values.each {|sym| ships += @grid.flatten.compact.count(sym)}
    ships
  end

  def setup?
    check = 100 - @grid.flatten.count("wave")
    return true if check == 17
    false
  end

  def empty?(pos = nil)
    if pos != nil
      x = pos[0]
      y = pos[-1]
      spot = @grid[x][y]
      return true if spot == nil
      false
    elsif @grid.flatten.compact == []
      return true
    elsif @grid.flatten.compact != []
      return false
    end
  end

  def ship?(pos)
    x = pos[0].to_i
    y = pos[-1].to_i
    if SHIP_SYMS.values.include?(@grid[x][y])
      return true
    end
    false
  end

  def distribute_ships
      until @grid.flatten.compact.length >= 17
        i = 0
        while i < SHIPS.keys.length
          @grid = @grid.transpose.map &:reverse
          ship = SHIPS.keys[i]
            start_pos = [(0..9).to_a.sample],[(0..9).to_a.sample]
            row = start_pos[0][0]
            col = start_pos[-1][0]
            if col + SHIPS[ship] < 10 &&
              @grid[row][col..(col+SHIPS[ship])].none? {|spot| spot.class == Symbol}
              @grid[row] = @grid[row].map.with_index do |spot, j|
                  if j >= col && j < col+SHIPS[ship]
                   SHIP_SYMS[ship]
                  else
                    spot
                  end
                end
              i+=1
            end
          end
      end
    end

  def won?
    return false if @grid.empty?
    return true if @grid.flatten.compact.all? {|spot| spot == :x}
    false
  end
end
