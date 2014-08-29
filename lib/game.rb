require_relative 'game_3x3.rb'
require_relative 'game_4x4.rb'

class Game

  attr_accessor :grid, :player_1, :player_2, :cpu, :mode, :size, :turn, :message, :result

  def initialize(opts)
    @size     = opts[:size]
    @mode     = opts[:mode]
    @turn     = opts[:turn]
    @grid     = opts[:grid] || get_grid(@size)
    @player_1 = 'X'
    @player_2 = 'O'
    @cpu      = 'O'
    @result   = nil
    @message  = opts[:message] || 'Welcome to the Fields of Strife'
  end

  def round(position)
    game     = game_class.new(session_hash)
    game.round(position)
    @grid    = game.grid
    @mode    = game.mode
    @size    = game.size
    @turn    = game.turn
    @message = game.message
    @result  = game.result
  end

  def session_hash
    {
      size: @size,
      mode: @mode,
      turn: @turn,
      message: @message,
      result: @result,
      grid: @grid
    }
  end

  private

  def game_class
    if @size == '4x4'
      Game4x4
    else
      Game3x3
    end
  end

  def get_grid(size)
    if size == '4x4'
      Game4x4::GRID
    else
      Game3x3::GRID
    end
  end

end
