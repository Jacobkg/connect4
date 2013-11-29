class Board

  def initialize(initial_board_state = nil)
    @board_state = [["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8]
    @board_state = initial_board_state unless initial_board_state.nil?
  end

  def print
    7.downto(0) do |i|
      0.upto(7) do |j|
        Kernel.print @board_state[j][i]
      end
      Kernel.print "\n"
    end
    puts [1,2,3,4,5,6,7,8].join
  end

  def board_state
    [@board_state[0].dup, @board_state[1].dup, @board_state[2].dup, @board_state[3].dup,
     @board_state[4].dup, @board_state[5].dup, @board_state[6].dup, @board_state[7].dup]
  end

  def copy
    Board.new(board_state)
  end

  def available_moves
    (0..7).to_a.select {|n| @board_state[n][7] == '-'}
  end

  def drop_piece(column, player)
    new_board_state = board_state
    0.upto(7) do |i|
      if new_board_state[column][i] == "-"
        new_board_state[column][i] = player
        break
      end
    end
    Board.new(new_board_state)
  end

  def count_left(x, y, player)
    return 0 if x <= 0 || @board_state[x - 1][y] != player
    return 1 + count_left(x - 1, y, player)
  end

  def count_right(x, y, player)
    return 0 if x >= 7 || @board_state[x + 1][y] != player
    return 1 + count_right(x + 1, y, player)
  end

  def count_up(x, y, player)
    return 0 if y >= 7 || @board_state[x][y + 1] != player
    return 1 + count_up(x, y + 1, player)
  end

  def count_down(x, y, player)
    return 0 if y <= 0 || @board_state[x][y - 1] != player
    return 1 + count_down(x, y - 1, player)
  end

  def count_up_left(x, y, player)
    return 0 if x <= 0 || @board_state[x - 1][y + 1] != player
    return 1 + count_up_left(x - 1, y + 1, player)
  end

  def count_up_right(x, y, player)
    return 0 if x >= 7 || @board_state[x + 1][y + 1] != player
    return 1 + count_up_right(x + 1, y + 1, player)
  end

  def count_down_left(x, y, player)
    return 0 if x <= 0 || y <= 0 || @board_state[x - 1][y - 1] != player
    return 1 + count_down_left(x - 1, y - 1, player)
  end

  def count_down_right(x, y, player)
    return 0 if x >= 7 || y >= 7 || @board_state[x + 1][y - 1] != player
    return 1 + count_down_right(x + 1, y - 1, player)
  end

  def count_max_in_a_row
    max_count = {"X" => 0, "O" => 0}
    0.upto(7) do |x|
      0.upto(7) do |y|
        player = board_state[x][y]
        next if player == "-"
        left_count = count_left(x, y, player)
        right_count = count_right(x, y, player)
        up_count = count_up(x, y, player)
        down_count = count_down(x, y, player)
        up_left_count = count_up_left(x, y, player)
        down_right_count = count_down_right(x, y, player)
        up_right_count = count_up_right(x, y, player)
        down_left_count = count_down_left(x, y, player)
        best_count = [left_count + right_count + 1, up_count + down_count + 1,
                      up_left_count + down_right_count + 1, up_right_count + down_left_count + 1].max
        if best_count > max_count[player]
          max_count[player] = best_count
        end
      end
    end
    max_count
  end

  def winner
    count_hash = count_max_in_a_row
    if count_hash["X"] >= 4
      return "X"
    elsif count_hash["O"] >= 4
      return "O"
    else
      return nil
    end
  end

end