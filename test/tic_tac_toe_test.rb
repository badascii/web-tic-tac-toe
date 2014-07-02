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

    it 'should accept player input' do
      fill_in 'grid_location', with: '2c'
      click_button 'Submit'
      page.has_content?('Movement accepted').must_equal(true)
    end

    it 'should record player input on the grid' do
      fill_in 'grid_location', with: 'c2'
      click_button 'Submit'
      within('#c2') do
        page.has_content?('X').must_equal(true)
      end
    end

    it 'should not allow incorrect input' do
      fill_in 'grid_location', with: 'f5'
      click_button 'Submit'
      page.has_content?('X').must_equal(false)
    end
  end
end