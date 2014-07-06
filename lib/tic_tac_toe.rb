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

  before do
    session['grid'] ||= GRID
  end

  get '/' do
    @grid = session['grid']
    erb :index
  end

  post '/' do
    @grid = session['grid']
    @grid_location = params[:grid_location]
    if (@grid.has_key?(@grid_location)) && (@grid[@grid_location] == 0)
      @grid[@grid_location] = 'X'
      @message = 'Movement accepted.'
    elsif (@grid.has_key?(@grid_location)) && (@grid[@grid_location] != 0)
      @message = 'Invalid input. That position is taken.'
    else
      @message = 'Invalid input. Please try again.'
    end
    if horizontal_win?('X')
      @message = 'Congratulations. You win!'
    end
    session['grid'] = @grid
    erb :index
  end

  private

  def horizontal_win?(mark)
    three_in_a_row?(mark, WIN_CONDITIONS[3]) || three_in_a_row?(mark, WIN_CONDITIONS[4]) || three_in_a_row?(mark, WIN_CONDITIONS[5])
  end

  def three_in_a_row?(mark, win_condition)
    (@grid[win_condition[0]] == mark) && (@grid[win_condition[1]] == mark) && (@grid[win_condition[2]] == mark)
  end

end