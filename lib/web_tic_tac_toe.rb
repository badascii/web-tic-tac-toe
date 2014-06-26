require 'sinatra/base'

class WebTicTacToe < Sinatra::Base
  get '/' do
    erb :index
  end
  
  post '/' do
    @message = "Movement accepted!"
    erb :index
  end
end
