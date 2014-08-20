require 'sinatra/base'
require_relative 'game_3x3.rb'
require_relative 'game_4x4.rb'

class Game
  attr_reader :size, :mode, :turn, :player_1, :player_2, :message, :cpu, :result, :grid
  
  def initialize(opts)
    @size = opts[:size]
    @mode = opts[:mode]
    @turn = opts[:turn]
    @player_1 = 'X'
    @player_2 = 'O'
    @cpu = 'O'
    @result = nil
    @grid = grid_for_size(@size)
    @message = opts[:message] || 'Welcome to the Fields of Strife'
  end
  
  def hash_for_session
    {
      size: @size,
      mode: @mode,
      message: @message,
      result: @result,
      grid: @grid
    }
  end
  
  def round(position)
    the_game = game_class.new(hash_for_session)
    the_game.round(position)
    @grid = the_game.grid
    @mode = the_game.mode
    @size = the_game.size
    @turn = the_game.turn
    @message = the_game.message
    @result = the_game.result
  end
  
  private
  
  def game_class
    if @size == '4x4'
      Game4x4
    else
      Game3x3
    end
  end
  
  def grid_for_size(size)
    if size == '4x4'
      Game4x4::GRID
    else
      Game3x3::GRID
    end
  end
end

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
    session['game'] = @game.hash_for_session
    erb :new_game
  end

  post '/game/move' do
    @game = Game.new(session['game'])
    @player_move = params[:grid_position]
    @game.round(@player_move)
    if @game.result
      session['result'] = @game.result
      redirect '/game/result'
    else
      session['game'] = @game.hash_for_session
      erb :new_game
    end
  end

  get '/game/result' do
    @result = session['result']
    erb :result
  end
end