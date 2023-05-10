# frozen_string_literal: true

require 'dotenv'
require 'trello'
require 'csv'

Dotenv.load

# Configure Trello with your API key and member token
Trello.configure do |config|
  config.developer_public_key = ENV['DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['MEMBER_TOKEN']
end

CardDetail = Struct.new(:title, :description, :label, :list)

class Exporter
  attr_reader :board_id

  def initialize(board_id)
    @board_id = board_id
  end

  def list
    board = Trello::Board.find(board_id)

    board.lists.flat_map do |list|
      list.cards.map do |card|
        CardDetail.new(
          card.name,
          card.desc,
          card.labels.map(&:name).first,
          list.name
        )
      end
    end
  end

  def execute
    CSV.open("output/card_details.csv", "wb") do |csv|
      csv << %w[Title Description Labels List Moved]
      list.each do |card_detail|
        csv << [card_detail.title, card_detail.description, card_detail.label, card_detail.list.upcase, "FALSE"]
      end
    end
  end
end
