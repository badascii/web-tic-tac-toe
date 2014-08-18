require 'sinatra/base'
require_relative 'game.rb'


class TicTacToe < Sinatra::Base
  enable :sessions

  get '/' do
    session.clear
    erb :index
  end

  post '/game' do
    session['grid'] = Game::GRID
    @game    = Game.new(session)
    @grid    = session['grid']
    @mode    = params[:mode]
    @size    = params[:size]
    @message = 'Welcome to the Fields of Strife'
    session['mode'] = @mode
    session['size'] = @size
    erb :game
  end

  post '/game/move' do
    @game        = Game.new(session)
    @player_move = params[:grid_position]
    @grid        = @game.grid
    @mode        = @game.mode
    @size        = @game.size
    @game.round(@player_move)

    @message     = @game.message
    session['grid']    = @game.grid
    session['turn']    = @game.turn
    session['message'] = @game.message
    # @player_1       = game.player_1
    # @player_2       = game.player_2
    # @cpu            = game.cpu
    # @turn           = game.turn
    # @message        = game.message
    # @result         = nil || game.result
    if @game.result
      session['result'] = @game.result
      redirect '/game/result'
    end

    erb :game
  end

  get '/game/result' do
    @result = session['result']
    erb :result
  end
end