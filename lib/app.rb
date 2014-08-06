require 'sinatra/base'
require_relative 'game.rb'

game = Game.new

class TicTacToe < Sinatra::Base
  enable :sessions

  before do
    session['grid'] ||= GRID
  end

  get '/' do
    erb :index
  end

  get '/game' do
    @grid    ||= session['grid']
    @mode    ||= game.mode
    @message   = 'Welcome to the Fields of Strife'
    erb :game
  end

  post '/game' do
    @mode ||= game.mode
    @grid ||= session['grid']

    session['grid'] = @grid
    session['mode'] = @mode
    erb :game
  end

  post '/game/move' do
    @mode ||= game.mode
    @grid ||= session['grid']
    @turn ||= game.player_1

    if @mode == 'human'
      if @turn == game.player_1
        game.get_player_input(game.player_1)
      elsif @turn == game.player_2
        game.get_player_input(game.player_2)
      end
    elsif @mode == 'cpu'
      game.get_player_input(game.player_1)
      game.cpu_turn
    end

    session['grid'] = @grid
    session['mode'] = @mode
    erb :game
  end
end