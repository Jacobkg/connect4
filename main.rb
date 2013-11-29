board = [["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8]

def print_board(board)
  7.downto(0) do |i|
    0.upto(7) do |j|
      print board[j][i]
    end
    print "\n"
  end
  puts [1,2,3,4,5,6,7,8].join
end

def copy_board(board)
  new_board = [["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8,["-"] * 8]
  0.upto(7) do |i|
    0.upto(7) do |j|
      new_board[i][j] = board[i][j]
    end
  end
  new_board
end

def request_user_move
  puts "Choose a column (1-8): "
  move = gets.chomp.to_i
  col = move - 1
end

def drop_piece!(board, column, player)
  0.upto(7) do |i|
    if board[column][i] == "-"
      board[column][i] = player
      break
    end
  end
end

def available_moves(board)
  (0..7).to_a.select {|n| board[n][7] == '-'}
end

def score(board)
  winner = winner(board)
  return 0 if winner.nil?
  return 1 if winner == "O"
  return -1
end

def minimax(board, depth, alpha, beta, maximizing_player)
  if depth == 0 || winner(board)
    return score(board)
  end
  if maximizing_player
    available_moves(board).each do |possible_move|
      test_board = copy_board(board)
      drop_piece! test_board, possible_move, "O"
      alpha = [alpha, minimax(test_board, depth - 1, alpha, beta, false)].max
      break if beta <= alpha
    end
    return alpha
  else
    available_moves(board).each do |possible_move|
      test_board = copy_board(board)
      drop_piece! test_board, possible_move, "X"
      beta = [beta, minimax(test_board, depth - 1, alpha, beta, true)].min
      break if beta <= alpha
    end
    return beta
  end
end

def compute_computer_move(board)
  best_move = nil
  best_score = -1_000_000
  available_moves(board).each do |possible_move|
    test_board = copy_board(board)
    drop_piece! test_board, possible_move, "O"
    score = minimax(test_board, 6, -1_000, 1_000, false)
    puts "Move #{possible_move} has score #{score}"
    if score > best_score
      best_move = possible_move
      best_score = score
    end
  end
  best_move
end

def count_left(board, x, y, player)
  return 0 if x <= 0 || board[x - 1][y] != player
  return 1 + count_left(board, x - 1, y, player)
end

def count_right(board, x, y, player)
  return 0 if x >= 7 || board[x + 1][y] != player
  return 1 + count_right(board, x + 1, y, player)
end

def count_up(board, x, y, player)
  return 0 if y >= 7 || board[x][y + 1] != player
  return 1 + count_up(board, x, y + 1, player)
end

def count_down(board, x, y, player)
  return 0 if y <= 0 || board[x][y - 1] != player
  return 1 + count_down(board, x, y - 1, player)
end

def count_up_left(board, x, y, player)
  return 0 if x <= 0 || board[x - 1][y + 1] != player
  return 1 + count_up_left(board, x - 1, y + 1, player)
end

def count_up_right(board, x, y, player)
  return 0 if x >= 7 || board[x + 1][y + 1] != player
  return 1 + count_up_right(board, x + 1, y + 1, player)
end

def count_down_left(board, x, y, player)
  return 0 if x <= 0 || y <= 0 || board[x - 1][y - 1] != player
  return 1 + count_down_left(board, x - 1, y - 1, player)
end

def count_down_right(board, x, y, player)
  return 0 if x >= 7 || y >= 7 || board[x + 1][y - 1] != player
  return 1 + count_down_right(board, x + 1, y - 1, player)
end

def count_max_in_a_row(board)
  max_count = {"X" => 0, "O" => 0}
  0.upto(7) do |x|
    0.upto(7) do |y|
      player = board[x][y]
      next if player == "-"
      left_count = count_left(board, x, y, player)
      right_count = count_right(board, x, y, player)
      up_count = count_up(board, x, y, player)
      down_count = count_down(board, x, y, player)
      up_left_count = count_up_left(board, x, y, player)
      down_right_count = count_down_right(board, x, y, player)
      up_right_count = count_up_right(board, x, y, player)
      down_left_count = count_down_left(board, x, y, player)
      best_count = [left_count + right_count + 1, up_count + down_count + 1,
                    up_left_count + down_right_count + 1, up_right_count + down_left_count + 1].max
      if best_count > max_count[player]
        max_count[player] = best_count
      end
    end
  end
  max_count
end

def winner(board)
  count_hash = count_max_in_a_row(board)
  if count_hash["X"] >= 4
    return "X"
  elsif count_hash["O"] >= 4
    return "O"
  else
    return nil
  end
end

drop_piece! board, 4, "O"
loop do
  print_board board
  col = request_user_move
  drop_piece! board, col, "X"
  break if winner(board)
  drop_piece! board, compute_computer_move(board), "O"
  break if winner(board)
  count_hash = count_max_in_a_row(board)
end

print_board board
puts "And the winner is: #{winner(board)}"
