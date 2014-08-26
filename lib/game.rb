require_relative 'game_3x3.rb'
require_relative 'game_4x4.rb'

class Game

  attr_accessor :grid, :player_1, :player_2, :cpu, :mode, :size, :turn, :message, :result

  def initialize(opts)
    @size = opts[:size]
    @mode = opts[:mode]
    @turn = opts[:turn]
    @player_1 = 'X'
    @player_2 = 'O'
    @cpu = 'O'
    @result = nil
    @grid = get_grid(@size)
    @message = opts[:message] || 'Welcome to the Fields of Strife'
  end

  def round(position)
    game = game_class.new(session_hash)
    game.round(position)
    @grid = game.grid
    @mode = game.mode
    @size = game.size
    @turn = game.turn
    @message = game.message
    @result = game.result
  end

  def session_hash
    {
      size: @size,
      mode: @mode,
      message: @message,
      result: @result,
      grid: @grid
    }
  end

  private

  def get_grid(size)
    if size == '4x4'
      Game4x4::GRID
    else
      Game3x3::GRID
    end
  end

  def switch_turns
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
    elsif valid_position_format?(position)
      @message = 'Invalid input. That position is taken.'
    else
      @message = 'Invalid input. That is not a valid position.'
    end
  end

  def valid_position_format?(position)
    (position =~ POSITION_REGEX) || (position =~ POSITION_REGEX_REVERSE)
  end

  def grid_full?
    !@grid.has_value?(0)
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
