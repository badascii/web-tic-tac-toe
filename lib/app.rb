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
    @message   = 'Choose a game mode'
    erb :game
  end

  post '/game' do
    @mode    ||= params[:mode]
    @grid    ||= session['grid']
    @message   = 'Welcome to the Fields of Strife'
    session['mode'] = @mode
    game.session = session
    erb :game
  end

  post '/game/move' do
    game.session = session
    @mode    ||= session['mode']
    @grid    ||= session['grid']
    @message ||= session['message']
    player_move = params[:grid_position]

    game.round(player_move)
    erb :game
    session = game.session
  end
end