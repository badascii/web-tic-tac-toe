require 'sinatra/base'

class TicTacToe < Sinatra::Base
  @grid = {"a1" => 0, "b1" => 0, "c1" => 0,
           "a2" => 0, "b2" => 0, "c2" => 0,
           "a3" => 0, "b3" => 0, "c3" => 0}

  get '/' do
    erb :index
  end

  post '/' do
    @message = 'Movement accepted'
    @grid_location = params[:grid_location]
    @grid[@grid_location] = 'X'
    erb :index
  end
end