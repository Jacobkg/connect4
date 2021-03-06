require_relative "./board"
require_relative "./computer"

def request_user_move
  puts "Choose a column (1-8): "
  move = gets.chomp.to_i
  col = move - 1
end

board = Board.new
#board = board.drop_piece(4, "O")
loop do
  puts "Heuristic Score for O: #{Computer.new("O").score(board)}"
  puts "Heuristic Score for X: #{Computer.new("X").score(board)}"
  board.print
  col = request_user_move
  board = board.drop_piece col, "X"
  break if board.winner
  board = board.drop_piece Computer.new("O").pick_move(board), "O"
  break if board.winner
end

board.print
puts "And the winner is: #{board.winner}"
