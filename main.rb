require_relative "./board"

def request_user_move
  puts "Choose a column (1-8): "
  move = gets.chomp.to_i
  col = move - 1
end

def score(board)
  winner = board.winner
  return heuristic_score(board) if winner.nil?
  return 999 if winner == "O"
  return -999
end

def minimax(board, depth, alpha, beta, maximizing_player)
  if depth == 0 || board.winner
    return score(board)
  end
  if maximizing_player
    board.available_moves.each do |possible_move|
      test_board = board.drop_piece possible_move, "O"
      alpha = [alpha, minimax(test_board, depth - 1, alpha, beta, false)].max
      break if beta <= alpha
    end
    return alpha
  else
    board.available_moves.each do |possible_move|
      test_board = board.drop_piece possible_move, "X"
      beta = [beta, minimax(test_board, depth - 1, alpha, beta, true)].min
      break if beta <= alpha
    end
    return beta
  end
end

def compute_computer_move(board)
  best_move = nil
  best_score = -1_000_000
  board.available_moves.each do |possible_move|
    test_board = board.drop_piece possible_move, "O"
    score = minimax(test_board, 5, -1_000, 1_000, false)
    puts "Move #{possible_move} has score #{score}"
    if score > best_score
      best_move = possible_move
      best_score = score
    end
  end
  best_move
end

def heuristic_score(board)
  count = 0
  0.upto(7) do |x|
    0.upto(7) do |y|
      player = "O"
      next unless board.board_state[x][y] == "X"
      count += board.count_left(x, y, player)
      count += board.count_right(x, y, player)
      count += board.count_up(x, y, player)
      count += board.count_down(x, y, player)
      count += board.count_up_left(x, y, player)
      count += board.count_down_right(x, y, player)
      count += board.count_up_right(x, y, player)
      count += board.count_down_left(x, y, player)
    end
  end
  count
end

board = Board.new
board = board.drop_piece(4, "O")
loop do
  board.print
  col = request_user_move
  board = board.drop_piece col, "X"
  break if board.winner
  board = board.drop_piece compute_computer_move(board), "O"
  break if board.winner
end

board.print
puts "And the winner is: #{board.winner}"
