require 'minitest/autorun'
require 'capybara'

require_relative '../lib/web_tic_tac_toe'

Capybara.app = WebTicTacToe

class TestWebTicTacToe < Minitest::Test
  include Capybara::DSL
  
  def test_web_landing
    visit '/'
    assert page.has_content?("math")
  end
  
end
