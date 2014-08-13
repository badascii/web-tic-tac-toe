class Game

  GRID = {'a1' => 0, 'b1' => 0, 'c1' => 0,
          'a2' => 0, 'b2' => 0, 'c2' => 0,
          'a3' => 0, 'b3' => 0, 'c3' => 0}

  WIN_CONDITIONS = [
    ['a1', 'a2', 'a3'], #   vertical win 0
    ['b1', 'b2', 'b3'], #   vertical win 1
    ['c1', 'c2', 'c3'], #   vertical win 2
    ['a1', 'b1', 'c1'], # horizontal win 3
    ['a2', 'b2', 'c2'], # horizontal win 4
    ['a3', 'b3', 'c3'], # horizontal win 5
    ['a1', 'b2', 'c3'], #   diagonal win 6
    ['a3', 'b2', 'c1']  #   diagonal win 7
    ]

  POSITION_REGEX         = /[abc][1-3]/
  POSITION_REGEX_REVERSE = /[1-3][abc]/

  attr_accessor :grid, :player_1, :player_2, :cpu, :mode, :turn, :message, :result

  def initialize(session)
    @player_1 = 'X'
    @player_2 = 'O'
    @cpu      = 'O'
    @grid     = session['grid']
    @mode     = session['mode']
    @turn     = session['turn'] || @player_1
    @message  = session['message']
    @result   = nil
  end

  def round(position)
    if @mode == 'human'
      get_player_input(position)
      if win?(@player_1)
        @result = "#{@player_1} wins! Congrats!"
      elsif win?(@cpu)
        @result = "#{@player_2} wins! Congrats!"
      end
    elsif @mode == 'cpu'
      get_player_input(position)
      cpu_turn
      if win?(@player_1)
        @result = 'You win. Congrats!'
      elsif win?(@cpu)
        @result = 'You lose. Really?'
      end
    end
  end

  def grid_full?
    !@grid.has_value?(0)
  end

  private

  def switch_players
    if @turn == @player_1
      @turn = @player_2
    elsif @turn == @player_2
      @turn = @player_1
    end
  end

  def get_player_input(position)
    if (valid_position_format?(position)) && (@grid[position] == 0)
      @grid[position] = @turn
      @message = 'Movement accepted.'
      switch_players
    elsif valid_position_format?(position)
      @message = 'Invalid input. That position is taken.'
    else
      @message = 'Invalid input. That is not a valid position.'
    end
  end

  def valid_position_format?(position)
    (position =~ POSITION_REGEX) || (position =~ POSITION_REGEX_REVERSE)
  end

  def win?(mark)
    vertical_win?(mark) || horizontal_win?(mark) || diagonal_win?(mark)
  end

  def horizontal_win?(mark)
    three_in_a_row?(mark, WIN_CONDITIONS[3]) || three_in_a_row?(mark, WIN_CONDITIONS[4]) || three_in_a_row?(mark, WIN_CONDITIONS[5])
  end

  def vertical_win?(mark)
    three_in_a_row?(mark, WIN_CONDITIONS[0]) || three_in_a_row?(mark, WIN_CONDITIONS[1]) || three_in_a_row?(mark, WIN_CONDITIONS[2])
  end

  def diagonal_win?(mark)
    three_in_a_row?(mark, WIN_CONDITIONS[6]) || three_in_a_row?(mark, WIN_CONDITIONS[7])
  end

  def three_in_a_row?(mark, win_condition)
    (@grid[win_condition[0]] == mark) && (@grid[win_condition[1]] == mark) && (@grid[win_condition[2]] == mark)
  end

  def cpu_turn
    win  = cpu_check_for_win(@cpu)
    loss = cpu_check_for_win(@player_1)

    if @grid.values.uniq.length == 2
      opening_move
    elsif win
      @grid[win]  = @cpu
    elsif loss
      @grid[loss] = @cpu
    elsif corner_defense?
      place_corner_defense
    elsif side_defense?
      place_side_defense
    elsif opposite_corners?
      @grid['a2'] = @cpu
    else
      optimal_move
    end
  end

  def cpu_check_for_win(mark)
    move = nil
    WIN_CONDITIONS.each do |condition|
      occupied_spaces = []
      open_space = false
      condition.each do |position|
        open_space = true if position_empty?(position)
        occupied_spaces << position if @grid[position] == mark
      end
      if occupied_spaces.length == 2 && open_space == true
        move = condition - occupied_spaces
        return move.first
      end
    end
    return move
  end

  def opening_move
    if position_empty?('b2')
      @grid['b2'] = @cpu
    else
      @grid['a1'] = @cpu
    end
  end

  def optimal_move
    if position_empty?('b1') && position_empty?('b3')
      @grid['b1'] = @cpu
    elsif position_empty?('a2') && position_empty?('c2')
      @grid['c2'] = @cpu
    else
      @grid.each do |key, value|
        if value == 0
          @grid[key] = @cpu
          break
        end
      end
    end
  end

  def position_empty?(position)
    @grid[position] == 0
  end

  def corner_defense?
    side_positions = [@grid['a2'], @grid['b1'], @grid['b3'], @grid['c2']]
    side_positions.count(0) == 1
  end

  def place_corner_defense
    if @grid['a1'] == 0
      @grid['a1'] = @cpu
    elsif @grid['c1'] == 0
      @grid['c1'] = @cpu
    elsif @grid['a3'] == 0
     @grid['a3'] = @cpu
    elsif @grid['c3'] == 0
      @grid['c3'] = @cpu
    end
  end

  def side_defense?
    corner_positions = [@grid['a1'], @grid['a3'], @grid['c1'], @grid['c3']]
    side_positions   = [@grid['a2'], @grid['b1'], @grid['b3'], @grid['c2']]
    (@grid['b2'] == @cpu) && (corner_positions.uniq.count == 2) && (side_positions.uniq.count == 3)
  end

  def place_side_defense
    if @grid['a2'] == 0
      @grid['a2'] = @cpu
    elsif @grid['b1'] == 0
      @grid['b1'] = @cpu
    elsif @grid['b3'] == 0
      @grid['b3'] = @cpu
    elsif @grid['c2'] == 0
      @grid['c2'] = @cpu
    end
  end

  def opposite_corners?
    (@grid['a1'] == @player_1 && @grid['c3'] == @player_1) || (@grid['a3'] == @player_1 && @grid['c1'] == @player_1)
  end
end
