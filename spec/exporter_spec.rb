require 'rspec'

require_relative 'spec_helper'
require_relative '../exporter'

RSpec.describe Exporter, vcr: true do
  let(:board_id) { 'ydR8z4TW' }
  let(:trello_board) { Exporter.new(board_id) }

  describe "#list" do
    it 'returns the correct card details' do
      VCR.use_cassette('technology-radar') do
        card_details = trello_board.list
        first_card = card_details.first

        expect(card_details).to all(be_a(CardDetail))
        expect(first_card.title).to eq('Rumale')
        expect(first_card.description).to eq("https://github.com/yoshoku/rumale\nThis seems to be a promising framework for Machine Learning in Ruby. It would be interesting to try it out in the future, should we need it.")
        expect(first_card.label).to eq("Programming Languages and Frameworks")
        expect(first_card.list).to eq('Assess')
      end
    end
  end
end