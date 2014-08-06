require 'sinatra/base'
require_relative 'game.rb'

game = Game.new

class TicTacToe < Sinatra::Base
  enable :sessions

  before do
    session['grid']        ||= GRID
    session['active_turn'] ||= game.player_1
  end

  get '/' do
    erb :index
  end

  get '/game' do
    @grid    ||= session['grid']
    @mode    ||= game.mode
    @message   = 'Choose a game mode'
    erb :game
  end

  post '/game' do
    @mode    ||= game.mode
    @grid    ||= session['grid']
    @message   = 'Welcome to the Fields of Strife'
    erb :game
  end

  post '/game/move' do
    @mode ||= game.mode
    @grid ||= session['grid']
    player_move = params[:grid_position]

    game.session = session
    game.round(player_move)
    erb :game
    session = game.session
  end
end