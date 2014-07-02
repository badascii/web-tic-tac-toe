require 'sinatra/base'

class TicTacToe < Sinatra::Base
  enable :sessions

  GRID = {"a1" => 0, "b1" => 0, "c1" => 0,
          "a2" => 0, "b2" => 0, "c2" => 0,
          "a3" => 0, "b3" => 0, "c3" => 0}

  before do
    session["grid"] ||= GRID
  end

  get '/' do
    @grid = session["grid"]
    erb :index
  end

  post '/' do
    @grid = session["grid"]
    @grid_location = params[:grid_location]
    if @grid.has_key?(@grid_location)
      @grid[@grid_location] = 'X'
      @message = 'Movement accepted'
    else
      @message = 'Invalid input. Please try again.'
    end
    session["grid"] = @grid
    erb :index
  end

end