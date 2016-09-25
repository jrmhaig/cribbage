require 'cribbage/deck'

RSpec.describe Cribbage::Deck do
  describe '#cards' do
    it 'starts with 52 items' do
      expect(Cribbage::Deck.new.cards.length).to eq 52
    end

    it 'contains only cards' do
      Cribbage::Deck.new.cards.each do |c|
        expect(c).to be_a Cribbage::Card
      end
    end

    it 'contains all different cards' do
      expect(Cribbage::Deck.new.cards.uniq.length).to eq 52
    end
  end
end
