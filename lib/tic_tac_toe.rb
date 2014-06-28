require 'sinatra/base'

class TicTacToe < Sinatra::Base
  get '/' do
    erb :index
  end
end