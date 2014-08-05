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

    session['grid'] = @grid
    session['mode'] = @mode
    erb :game
  end
end