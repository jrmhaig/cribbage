require 'cribbage/deck'

RSpec.describe Cribbage::Deck do
  let(:deck) { Cribbage::Deck.new }

  describe '#cards' do
    it 'starts with 52 items' do
      expect(deck.cards.length).to eq 52
    end

    it 'contains only cards' do
      deck.cards.each do |c|
        expect(c).to be_a Cribbage::Card
      end
    end

    it 'contains all different cards' do
      expect(deck.cards.uniq{ |c| "#{c.rank} #{c.suit}"}.length).to eq 52
    end
  end

  describe '#deal' do
    it 'returns the first card in the deck' do
      c = deck.cards[0]
      expect(deck.deal).to eq c
    end

    it 'reduces the number of cards in the deck' do
      expect{deck.deal}.to change(deck.cards, :length). by -1
    end

    it 'takes the first card out of the deck' do
      c = deck.cards[0]
      deck.deal
      # Note, the includes matcher uses the include? method, which uses ==
      expect(deck.cards.index{ |a| a.eql? c }).to be_nil
    end
  end
end
