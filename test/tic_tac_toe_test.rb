require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require_relative '../lib/tic_tac_toe'

Capybara.app = TicTacToe

describe TicTacToe do
  include Capybara::DSL

  describe 'landing page' do
    before do
      visit '/'
    end

    it 'should send a successful response' do
      page.status_code.must_equal(200)
    end

    it 'should display greeting text' do
      page.has_content?('TIC-TAC-TOE').must_equal(true)
      page.has_button?('Submit').must_equal(true)
    end
  end
end