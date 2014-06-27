require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/tic_tac_toe'

Capybara.app = TicTacToe

describe TicTacToe do
  include Capybara::DSL

  describe 'landing page' do
    before do
      visit '/'
    end
  end
end