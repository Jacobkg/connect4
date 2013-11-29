connect4
========
This is an AI opponent for playing Connect Four - http://en.wikipedia.org/wiki/Connect_Four

Instructions
========
To play, clone the repo and then run
```
$ ruby main.rb
```
Use the number 1 - 8 to specify which column to play on your turn.

Opponent Information
========
The AI opponent is programmed to search the game tree using the minimax algorithm with alpha/beta pruning. The game tree is too deep to fully explore, so a simple heuristic scoring function is used to evaluate non-leaf nodes beyond a depth of 5.

Although the game of Connect Four has been fully solved, the opponent AI is not believed to play optimally and should be defeatable.
