require 'cribbage/card'

class Cribbage
  class Deck
    attr_reader :cards

    def initialize
      @cards = []

      [:spades, :hearts, :diamonds, :clubs].each do |suit|
        (1..10).each do |rank|
          @cards << Cribbage::Card.new(rank, suit)
        end
        [:jack, :queen, :king].each do |rank|
          @cards << Cribbage::Card.new(rank, suit)
        end
      end

      # Do they want to be pre-shuffled?
      @cards.shuffle!
    end

    def deal
      @cards.shift
    end
  end
end
