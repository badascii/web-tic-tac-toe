require 'sinatra/base'
require_relative 'game'
require_relative 'game_3x3'
require_relative 'game_4x4'

class TicTacToe < Sinatra::Base
  enable :sessions

  get '/' do
    session.clear
    erb :index
  end

  post '/game' do
    opts = {
      size: params[:size],
      mode: params[:mode]
    }
    @game = Game.new(opts)
    session['game'] = @game.session_hash
    erb :game
  end

  post '/game/move' do
    @game = Game.new(session['game'])
    @player_move = params[:grid_position]
    @game.round(@player_move)

    if @game.result
      session['result'] = @game.result
      redirect '/game/result'
    else
      session['game'] = @game.session_hash
      erb :game
    end
  end

  # TODO: Add 'New Game' button to this page
  get '/game/result' do
    @result = session['result']
    erb :result
  end
end