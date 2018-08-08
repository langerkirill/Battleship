
class ComputerPlayer
  attr_reader :name

  def initialize(name)
    @name = name
    @computer_board = Array.new(10) {Array.new(10, "wave")}
  end

  def get_guess
    puts "\nBeep, Boop, I am #{self.name}"
      choices = []
      @computer_board.each_with_index do |row,i|
        row.each_with_index do |spot,j|
          if spot == "!!!!"
            choices << [i,j+1]
            choices << [i,j-1]
            choices << [(i-1),j]
            choices << [(i+1),j]
          end
        end
      end
      choices.select! {|move| move if move.all? {|num| num < 10}}
      choices.select! {|move| move if move.all? {|num| num > -1}}
      choices.reject! {|move| move if @computer_board[move[0]][move[-1]] != "wave"}
    unless choices == []
      return choices.sample
    end
    while true
      if smart_guess != false
        return smart_guess
      else
        strike = []
        2.times {trike << (0..9).to_a.sample}
          if @computer_board[strike[0]][strike[-1]] == "wave"
            return [strike[0], strike[-1]]
          end
        end
      end
    end

  def smart_guess
    flat_board = @computer_board.flatten
    flat_board.each_with_index do |spot, i|
      if spot == "wave" && flat_board[i+1] == "wave" && flat_board[i+2] == "wave" &&
         flat_board[i+10] == "wave" && flat_board[i+11] == "wave" && flat_board[i+12] == "wave" &&
         flat_board[i+20] == "wave" && flat_board[i+21] == "wave" && flat_board[i+22] == "wave" &&
         ans = [i+11][0].to_s
         return [ans[0],ans[-1]]
      end
    end
    false
  end

  def user_board_change(pos, hit)
    x = pos[0].to_i
    y = pos[-1].to_i
    if hit
      @computer_board[x][y] = "!!!!"
    else
      @computer_board[x][y] = "miss"
    end
  end

  def user_board_show
    hits = @computer_board.flatten.count("!!!!")
  end
end
