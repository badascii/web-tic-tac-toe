require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require_relative '../lib/tic_tac_toe'

Capybara.app = TicTacToe

describe TicTacToe do
  include Capybara::DSL

  describe 'landing page' do
    before do
      Capybara.reset_sessions!
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
      fill_in 'grid_location', with: 'c2'
      click_button 'Submit'
      page.has_content?('Movement accepted.').must_equal(true)
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
      within('#grid') do
        page.has_content?('X').must_equal(false)
      end
      page.has_content?('Invalid input. Please try again.').must_equal(true)
    end

    it 'should only allow input for open spaces' do
      fill_in 'grid_location', with: 'c2'
      click_button 'Submit'
      fill_in 'grid_location', with: 'c2'
      click_button 'Submit'
      page.has_content?('Invalid input. That position is taken.').must_equal(true)
    end

    it 'should end the game when the grid is full' do
      fill_in 'grid_location', with: 'a1'
      click_button 'Submit'
      fill_in 'grid_location', with: 'b1'
      click_button 'Submit'
      fill_in 'grid_location', with: 'c1'
      click_button 'Submit'
      fill_in 'grid_location', with: 'a2'
      click_button 'Submit'
      fill_in 'grid_location', with: 'b2'
      click_button 'Submit'
      fill_in 'grid_location', with: 'c2'
      click_button 'Submit'
      fill_in 'grid_location', with: 'a3'
      click_button 'Submit'
      fill_in 'grid_location', with: 'b3'
      click_button 'Submit'
      fill_in 'grid_location', with: 'c3'
      click_button 'Submit'
      page.has_button?('Submit').must_equal(false)
    end

    it 'should tell the player when they have won' do
      fill_in 'grid_location', with: 'a1'
      click_button 'Submit'
      fill_in 'grid_location', with: 'b1'
      click_button 'Submit'
      fill_in 'grid_location', with: 'c1'
      click_button 'Submit'
      page.has_content?('You win!').must_equal(true)
    end
  end
end