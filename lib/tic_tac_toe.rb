require 'sinatra/base'

class TicTacToe < Sinatra::Base
  enable :sessions

  GRID = {"a1" => 0, "b1" => 0, "c1" => 0,
          "a2" => 0, "b2" => 0, "c2" => 0,
          "a3" => 0, "b3" => 0, "c3" => 0}

  WIN_CONDITIONS = [
  ["a1", "a2", "a3"], #   vertical win 0
  ["b1", "b2", "b3"], #   vertical win 1
  ["c1", "c2", "c3"], #   vertical win 2
  ["a1", "b1", "c1"], # horizontal win 3
  ["a2", "b2", "c2"], # horizontal win 4
  ["a3", "b3", "c3"], # horizontal win 5
  ["a1", "b2", "c3"], #   diagonal win 6
  ["a3", "b2", "c1"]  #   diagonal win 7
  ]

  POSITION_REGEX         = /[abc][1-3]/
  POSITION_REGEX_REVERSE = /[1-3][abc]/

  before do
    session['grid'] ||= GRID
  end

  get '/' do
    @grid = session['grid']
    erb :index
  end

  post '/' do
    @player_mark  = 'X'
    @cpu_mark     = 'O'
    @player_input = params[:grid_location]
    @grid         = session['grid']

    if valid_position_format?(@player_input) && @grid[@player_input] == 0
      @grid[@player_input] = @player_mark
      @message = 'Movement accepted.'
      cpu_turn
    elsif valid_position_format?(@player_input)
      @message = 'Invalid input. That position is taken.'
    else
      @message = 'Invalid input. Please try again.'
    end
    if win?(@player_mark)
      @message = 'Congratulations. You win!'
    elsif win?(@cpu_mark)
      @message = 'You lose. Really?'
    end
    session['grid'] = @grid
    erb :index
  end

  private

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
    win  = cpu_check_for_win(@cpu_mark)
    loss = cpu_check_for_win(@player_mark)

    if @grid.values.uniq.length == 2
      opening_move
    elsif win
      @grid[win]  = @cpu_mark
    elsif loss
      @grid[loss] = @cpu_mark
    else
      @grid['b3'] = @cpu_mark
    end
  end

  def opening_move
    if position_empty?('b2')
      @grid['b2'] = @cpu_mark
    else
      @grid['b1'] = @cpu_mark
    end
  end

  def position_empty?(position)
    @grid[position] == 0
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
end