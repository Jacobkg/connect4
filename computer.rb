class Computer

  attr_reader :player
  def initialize(player)
    @player = player
  end

  def pick_move(board)
    best_move = nil
    best_score = -1_000_000
    board.available_moves.each do |possible_move|
      test_board = board.drop_piece possible_move, player
      score = minimax(test_board, 5, -1_000, 1_000, false)
      puts "Move #{possible_move + 1} has score #{score}"
      if score > best_score
        best_move = possible_move
        best_score = score
      end
    end
    best_move
  end

  def score(board)
    winner = board.winner
    return heuristic_score(board) if winner.nil?
    return 999 if winner == player
    return -999
  end

  private

    def heuristic_score(board)
      count = 0
      0.upto(7) do |x|
        0.upto(7) do |y|
          next if board.board_state[x][y] == other_player
          count += board.count(x, y, :left, :none, player)
          count += board.count(x, y, :right, :none, player)
          count += board.count(x, y, :none, :up, player)
          count += board.count(x, y, :none, :down, player)
          count += board.count(x, y, :left, :up, player)
          count += board.count(x, y, :right, :down, player)
          count += board.count(x, y, :right, :up, player)
          count += board.count(x, y, :left, :down, player)
        end
      end
      count
    end

    def minimax(board, depth, alpha, beta, maximizing_player)
      if depth == 0 || board.winner
        return score(board)
      end
      if maximizing_player
        board.available_moves.each do |possible_move|
          test_board = board.drop_piece possible_move, player
          alpha = [alpha, minimax(test_board, depth - 1, alpha, beta, false)].max
          break if beta <= alpha
        end
        return alpha
      else
        board.available_moves.each do |possible_move|
          test_board = board.drop_piece possible_move, other_player
          beta = [beta, minimax(test_board, depth - 1, alpha, beta, true)].min
          break if beta <= alpha
        end
        return beta
      end
    end

    def other_player
      @player == "X" ? "O" : "X"
    end

end