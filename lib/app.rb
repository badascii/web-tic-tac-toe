require 'sinatra/base'
require_relative 'game_3x3.rb'
require_relative 'game_4x4.rb'

class TicTacToe < Sinatra::Base
  enable :sessions

  get '/' do
    session.clear
    erb :index
  end

  post '/game' do
    if params[:size] == '3x3'
      session['grid'] = Game3x3::GRID
    elsif params[:size] == '4x4'
      session['grid'] = Game4x4::GRID
    end
    # session['grid'] = Game.grid_for_size(params[:size])
    @grid    = session['grid']
    @mode    = params[:mode]
    @size    = params[:size]
    @message = 'Welcome to the Fields of Strife'
    session['mode'] = @mode
    session['size'] = @size
    erb :game
  end

  post '/game/move' do
    if session['size'] == '3x3'
      @game = Game3x3.new(session)
    elsif session['size'] == '4x4'
      @game = Game4x4.new(session)
    end
    # @game = Game.new(session)
    @player_move = params[:grid_position]
    @grid        = @game.grid
    @player_1    = @game.player_1
    @player_2    = @game.player_2
    @mode        = @game.mode
    @size        = @game.size

    @game.round(@player_move)

    @message     = @game.message
    @turn        = @game.turn
    session['turn']    = @turn
    session['grid']    = @game.grid
    session['message'] = @game.message

    if @game.result
      session['result'] = @game.result
      redirect '/game/result'
    else
      erb :game
    end
  end

  # TODO: Add 'New Game' button to this page
  get '/game/result' do
    @result = session['result']
    erb :result
  end
end