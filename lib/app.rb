require 'sinatra/base'
require_relative 'game.rb'


class TicTacToe < Sinatra::Base
  enable :sessions

  get '/' do
    erb :index
  end

  post '/game' do
    session['grid'] = Game::GRID
    @mode    = params[:mode]
    @grid    = session['grid']
    @message = 'Welcome to the Fields of Strife'
    session['mode'] = @mode
    erb :game
  end

  post '/game/move' do
    game = Game.new(session)

    @player_move = params[:grid_position]
    game.round(@player_move)
    session['grid'] = game.grid
    @grid    = game.grid
    @mode    = game.mode
    @message = game.message
    erb :game
  end
end