require 'sinatra/base'

class WebTicTacToe < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    @message = "Movement accepted!"
    @grid_location = params[:grid_location]
    erb :index
  end
end
