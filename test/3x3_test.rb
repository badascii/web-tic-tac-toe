require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require_relative '../lib/app'

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

    it 'should have a Start Game button' do
      page.has_button?('Start').must_equal(true)
    end

    it 'should allow the user to choose their opponent' do
      choose('human')
      choose('3x3')
      click_button 'Start'
      page.has_content?('Player vs Player').must_equal(true)
      page.has_content?('3x3').must_equal(true)
    end
  end

  describe 'input' do
    before do
      Capybara.reset_sessions!
      visit '/'
      choose('cpu')
      choose('3x3')
      click_button 'Start'
    end

    it 'should have a Submit button' do
      page.has_button?('Submit').must_equal(true)
    end

    it 'should accept player input' do
      fill_in 'grid_position', with: 'c2'
      click_button 'Submit'
      page.has_content?('Movement accepted.').must_equal(true)
    end

    it 'should record player input on the grid' do
      fill_in 'grid_position', with: 'c2'
      click_button 'Submit'
      within('#c2') do
        page.has_content?('X').must_equal(true)
      end
    end

    it 'should not allow incorrect input' do
      fill_in 'grid_position', with: 'f5'
      click_button 'Submit'
      within('#grid') do
        page.has_content?('X').must_equal(false)
      end
      page.has_content?('Invalid input. That is not a valid position.').must_equal(true)
    end

    it 'should only allow input for open spaces' do
      fill_in 'grid_position', with: 'c2'
      click_button 'Submit'
      fill_in 'grid_position', with: 'c2'
      click_button 'Submit'
      page.has_content?('Invalid input. That position is taken.').must_equal(true)
    end

    it 'should end the game when there is a stalemate' do
      fill_in 'grid_position', with: 'b2'
      click_button 'Submit'
      fill_in 'grid_position', with: 'b1'
      click_button 'Submit'
      fill_in 'grid_position', with: 'a3'
      click_button 'Submit'
      fill_in 'grid_position', with: 'c2'
      click_button 'Submit'
      fill_in 'grid_position', with: 'c3'
      click_button 'Submit'
      page.has_content?('Stalemate').must_equal(true)
    end
  end

  describe 'cpu match' do
    before do
      Capybara.reset_sessions!
      visit '/'
      choose('cpu')
      choose('3x3')
      click_button 'Start'
    end

    it 'should notify the player that it is a CPU match' do
      page.has_content?('Player vs CPU').must_equal(true)
    end

    it 'should place the initial CPU move in B2 if open' do
      fill_in 'grid_position', with: 'a1'
      click_button 'Submit'

      within('#a1') do
        page.has_content?('X').must_equal(true)
      end
      within('#b2') do
        page.has_content?('O').must_equal(true)
      end
    end

    it 'should place winning CPU moves' do
      fill_in 'grid_position', with: 'a1'
      click_button 'Submit'
      fill_in 'grid_position', with: 'a2'
      click_button 'Submit'
      fill_in 'grid_position', with: 'c3'
      click_button 'Submit'
      page.has_content?('You lose. Really?').must_equal(true)
    end

    it 'should place loss-preventing CPU moves' do
      fill_in 'grid_position', with: 'b2'
      click_button 'Submit'
      fill_in 'grid_position', with: 'a2'
      click_button 'Submit'
      within('#c2') do
        page.has_content?('O').must_equal(true)
      end
    end

    it 'should place strategic CPU moves in the absense of other conditions' do
      fill_in 'grid_position', with: 'c3'
      click_button 'Submit'
      fill_in 'grid_position', with: 'a2'
      click_button 'Submit'
      within('#b1') do
        page.has_content?('O').must_equal(true)
      end
    end

    it 'should place CPU corner moves in specific game states' do
      fill_in 'grid_position', with: 'c3'
      click_button 'Submit'
      fill_in 'grid_position', with: 'b1'
      click_button 'Submit'
      fill_in 'grid_position', with: 'a2'
      click_button 'Submit'
      within('#a1') do
        page.has_content?('O').must_equal(true)
      end
    end

    it 'should place CPU side moves in specific game states' do
      fill_in 'grid_position', with: 'c3'
      click_button 'Submit'
      fill_in 'grid_position', with: 'b1'
      click_button 'Submit'
      within('#c2') do
        page.has_content?('O').must_equal(true)
      end
    end

    it 'should have the CPU defend against opposite corner opening moves' do
      fill_in 'grid_position', with: 'a1'
      click_button 'Submit'
      fill_in 'grid_position', with: 'c3'
      click_button 'Submit'
      within('#a2') do
        page.has_content?('O').must_equal(true)
      end
    end
  end

  describe 'human match' do
    before do
      Capybara.reset_sessions!
      visit '/'
      choose('human')
      choose('3x3')
      click_button 'Start'
    end

    it 'should notify the player that it is a human match' do
      page.has_content?('Player vs Player').must_equal(true)
    end

    it 'should record 2nd player input on the grid' do
      fill_in 'grid_position', with: 'c2'
      click_button 'Submit'
      fill_in 'grid_position', with: 'a1'
      click_button 'Submit'

      within('#c2') do
        page.has_content?('X').must_equal(true)
      end

      within('#a1') do
        page.has_content?('O').must_equal(true)
      end
    end

    it 'should display whose turn it is' do
      page.has_content?('Player 1 Turn').must_equal(true)
      fill_in 'grid_position', with: 'a1'
      click_button 'Submit'
      page.has_content?('Player 2 Turn').must_equal(true)
    end
  end

  describe 'result' do
    before do
      Capybara.reset_sessions!
      visit '/game/result'
    end

    it 'should visit the result page' do
      page.status_code.must_equal(200)
    end
  end

  describe 'consecutive games' do
    it 'should reset game state' do
      Capybara.reset_sessions!
      visit '/'
      choose('human')
      choose('3x3')
      click_button 'Start'
      fill_in 'grid_position', with: 'a2'
      click_button 'Submit'

      visit '/'
      choose('cpu')
      choose('3x3')
      click_button 'Start'
      fill_in 'grid_position', with: 'c1'
      click_button 'Submit'

      within('#grid') do
        page.has_content?('X').must_equal(true)
        page.has_content?('O').must_equal(true)
      end
    end
  end
end