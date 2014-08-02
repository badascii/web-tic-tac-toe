require 'sinatra/base'
require_relative 'game.rb'

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
    @mode    ||= params[:mode]
    @message   = 'Welcome to the Fields of Strife'
    erb :game
  end

  # fresh game
  post '/game' do

    @game = Game.new
    @mode           = session['mode'] || params[:mode]
    @grid         ||= session['grid']


    session['grid'] = @grid
    session['mode'] = @mode
    erb :game
  end


end