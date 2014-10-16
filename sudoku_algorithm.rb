class Sudoku
  attr_accessor :board_string, :boxes, :index
  POTENTIALS = ("1".."9").to_a

  def initialize(board_string)
    @board_string = board_string
    @boxes = []
    @index = 0
  end

  # Series of steps to display and solve the board
  def solve!
    before = Time.now
    solve_with_recursive_backtracking
    puts "Not solved!" if !solved?
    puts "Solved!" if solved?
    puts "Solved this board in: \n #{Time.now - before}"
  end

  # Checks if the board is complete and returns true if there are no zeros left
  def solved?
    return true unless board_string.include?("0")
  end

  # This clears the terminal screen so solving of board is viewable
  def clear_then_display
    print "\e[2J"
    print "\e[H"
    show_board
  end

  # Constructs a board that for viewing in terminal
  def show_board
    b = board_string.clone
    b.split(//).each_with_index do |num, index|
      print "#{num} "
      print "| " if (index+1) % 3 == 0 && index != 0 && (index+1) % 9 != 0
      print "\n" if (index+1) % 9 == 0 && index != 0
      print "---------------------\n" if (index+1) % 27 == 0 && index != 0 && index != 80
    end
  end

  private

  # Finds the next zero with the least number of possible solutions. If it has only 1 possible answer, it instantly uses it.  Return value is the index position of the number in board_string
  def next_zero
    smallest_index = nil
    smallest = 9
    index = 0
    board_string.each_char do |char|
      if char == "0"
        possible_nums = []
        POTENTIALS.each { |number| possible_nums << number if check_all(number, index) }
        return index if possible_nums.length == 1
        if possible_nums.length < smallest
          smallest = possible_nums.length
          smallest_index = index
        end
      end
    index += 1
    end
    smallest_index
  end

  # Uses Recursive Backtracking to solve the board. Returns true if solved and false otherwise.
  def solve_with_recursive_backtracking
    clear_then_display
    next_to_guess = next_zero
    if solved?
      return true
    else
      possible_nums = []
      POTENTIALS.each do |num|
        if check_all(num, next_to_guess)
          board_string[next_to_guess] = num
          if solve_with_recursive_backtracking
            return true
          else
            board_string[next_to_guess] = "0"
          end
        end
      end
    end
    false
  end

  # Returns true if check_row, check_col, and check_box all pass
  def check_all(number, index)
    return false if !check_row(number, index)
    return false if !check_col(number, index)
    return false if !check_box(number, index)
    return true
  end

  def check_row(number, index)
    rows = create_rows
    return false if rows[index / 9].include?(number)
    return true
  end

  def check_col(number, index)
    cols = create_cols
    return false if cols[index % 9].include?(number)
    return true
  end

  def check_box(number, index)
    boxes = create_boxes
    if [0, 1, 2, 9, 10, 11, 18, 19, 20].include?(index)
      box_index = 0
    elsif [3, 4, 5, 12, 13, 14, 21, 22, 23].include?(index)
      box_index = 1
    elsif [6, 7, 8, 15, 16, 17, 24, 25, 26].include?(index)
      box_index = 2
    elsif [27, 28, 29, 36, 37, 38, 45, 46, 47].include?(index)
      box_index = 3
    elsif [30, 31, 32, 39, 40, 41, 48, 49, 50].include?(index)
      box_index = 4
    elsif [33, 34, 35, 42, 43, 44, 51, 52, 53].include?(index)
      box_index = 5
    elsif [54, 55, 56, 63, 64, 65, 72, 73, 74].include?(index)
      box_index = 6
    elsif [57, 58, 59, 66, 67, 68, 75, 76, 77].include?(index)
      box_index = 7
    elsif [60, 61, 62, 69, 70, 71, 78, 79, 80].include?(index)
      box_index = 8
    end
    return false if boxes[box_index].include?(number)
    return true
  end

  # Builds up the rows to be checked
  def create_rows
    rows = []
    board_copy = board_string.clone
    9.times do rows << board_copy.slice!(0..8) end
    rows
  end

  # Builds up the columns to be checked
  def create_cols
    cols = []
    (0..9).each do |column|
      cols << "#{board_string[column]}#{board_string[column+9]}#{board_string[column+18]}#{board_string[column+27]}#{board_string[column+36]}#{board_string[column+45]}#{board_string[column+54]}#{board_string[column+63]}#{board_string[column+72]}"
    end
    cols
  end

  # Builds up the boxes to be checked
  def create_boxes
    boxes = []
    (0..2).each do |vert_offset|
      (27*vert_offset..(27*vert_offset+6)).step(3) { |offset| boxes << "#{board_string[offset..offset+2]}#{board_string[offset+9..offset+11]}#{board_string[offset+18..offset+20]}" }
    end
    boxes
  end
end  # End of Sudoku class

# board_string = "290500007700000400004738012902003064800050070500067200309004005000080700087005109"
# board_string = "480006902002008001900370060840010200003704100001060049020085007700900600609200018"
# board_string = "005030081902850060600004050007402830349760005008300490150087002090000600026049503"
# board_string = "030500804504200010008009000790806103000005400050000007800000702000704600610300500"
# board_string = "300000000050703008000028070700000043000000000003904105400300800100040000968000200"


# Peter Norvig 11 hardest boards
norvig_11_hardest_boards = %w(850002400720000009004000000000107002305000900040000000000080070017000000000036040
                              005300000800000020070010500400005300010070006003200080060500009004000030000009700
                              120040000005069010009000500000000070700052090030000002090600050400900801003000904
                              000570030100000020700023400000080004007004000490000605042000300000700900001800000
                              700152300000000920000300000100004708000000060000000000009000506040907000800006010
                              100007090030020008009600500005300900010080002600004000300000010040000007007000300
                              100034080000800500004060021018000000300102006000000810520070900006009000090640002
                              000920000006803000190070006230040100001000700008030029700080091000507200000064000
                              060504030100090008000000000900050006040602070700040005000000000400080001050203040
                              700000400020070080003008079900500300060020090001097006000300900030040060009001035
                              000070020800000006010205000905400008000000000300008501000302080400000009070060000)

game = Sudoku.new(norvig_11_hardest_boards.sample)
game.solve!