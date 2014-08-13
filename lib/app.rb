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
    @player_1 = game.player_1
    @player_2 = game.player_2
    @cpu      = game.cpu
    @grid     = game.grid
    @mode     = game.mode
    @turn     = game.turn
    @message  = game.message
    @result   = nil || game.result

    if @result
      session['result'] = @result
      redirect '/game/result'
    end

    erb :game
  end

  get '/game/result' do
    @result = session['result']
    erb :result
  end
end