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
    active_turn = session['turn']
    player_move = params[:grid_location]

    if @mode == 'human'
      if active_turn == game.player_1
        @grid[player_move] = active_turn
        session['turn'] = game.player_2
      elsif active_turn == game.player_2
        @grid[player_move] = active_turn
        session['turn'] = game.player_1
      end
    elsif @mode == 'cpu'
      @grid[player_move] = game.player_1
      game.cpu_turn
    end

    session['grid'] = @grid
    session['mode'] = @mode
    erb :game
  end
end