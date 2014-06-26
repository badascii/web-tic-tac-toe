require 'sinatra/base'

class WebTicTacToe < Sinatra::Base
  get '/' do
    erb :index
  end
  
  post '/' do
    @grid_location = params[:grid_location]
    @message = "Movement accepted!"
    erb :index
  end
end
