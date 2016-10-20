require 'cribbage/card'

class Cribbage
  class Deck < Array
    attr_reader :cards

    def initialize
      super

      [:spades, :hearts, :diamonds, :clubs].each do |suit|
        (1..10).each do |rank|
          self << Cribbage::Card.new(rank, suit)
        end
        [:jack, :queen, :king].each do |rank|
          self << Cribbage::Card.new(rank, suit)
        end
      end

      # Do they want to be pre-shuffled?
      shuffle!
    end

    def deal
      shift
    end
  end
end
