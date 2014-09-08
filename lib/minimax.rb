class Minimax
  def score(game, depth)
    if game.win?(@player_1)
      return 10 - depth
    elsif game.win?(@player_2)
      return depth - 10
    else
      return 0
    end
  end

  def minimax(game, depth)
    return score(game, depth) if game.game_over?
    depth += 1
    scores = [] # an array of scores
    moves  = []  # an array of moves

    # Populate the scores array, recursing as needed
    available_moves(game.grid).each do |move|
      game.grid[move] = game.cpu
      possible_game = game
      scores.push(minimax(possible_game, depth))
      moves.push(move)
    end

    # Do the min or the max calculation
    if game.turn == game.player_1
      # This is the max calculation
      max_score_index = scores.each_with_index.max[1]
      game.cpu_move = moves[max_score_index]
      return scores[max_score_index]
    else
      # This is the min calculation
      min_score_index = scores.each_with_index.min[1]
      game.cpu_move = moves[min_score_index]
      return scores[min_score_index]
    end
  end

  def available_moves(grid)
    moves = []
    grid.each do |location|
      if location == 0
        moves << location
      end
    end
    return moves
  end
end