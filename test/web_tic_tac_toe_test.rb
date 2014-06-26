require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require_relative '../lib/web_tic_tac_toe'

Capybara.app = WebTicTacToe

describe WebTicTacToe do
  include Capybara::DSL
  
  describe 'landing page' do
    before do
      visit '/'
    end
    
    it 'should successfully respond' do
      page.status_code.must_equal(200)
    end
    
    it 'should allow user input for placement' do
      fill_in 'Grid location', with: '2c'
      click_button 'Move!'
      page.status_code.must_equal(200)
      page.has_content?('Movement accepted!').must_equal(true)
      page.has_content?('Your movement was: 2c').must_equal(true)
    end
  end
  
end