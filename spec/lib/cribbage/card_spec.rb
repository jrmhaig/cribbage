require 'cribbage/card'

RSpec.describe Cribbage::Card do
  describe '#value' do
    it 'returns the value of a number card' do
      (1..10).each do |n|
        expect(Cribbage::Card.new(n, :spades).value).to eq n
      end
    end

    it 'returns the value of a face card' do
      expect(Cribbage::Card.new(:ace, :spades).value).to eq 1
      expect(Cribbage::Card.new(:jack, :spades).value).to eq 10
      expect(Cribbage::Card.new(:queen, :spades).value).to eq 10
      expect(Cribbage::Card.new(:king, :spades).value).to eq 10
    end
  end

  describe '#==' do
    let(:card1) { Cribbage::Card.new(7, :spades) }
    let(:card2) { Cribbage::Card.new(7, :spades) }
    let(:card3) { Cribbage::Card.new(7, :hearts) }
    let(:card4) { Cribbage::Card.new(3, :spades) }
    let(:card5) { Cribbage::Card.new(:king, :diamonds) }

    it 'matches identical cards' do
      expect(card1).to eq card2
    end

    it 'does not match card with different suit' do
      expect(card1).not_to eq card3
    end

    it 'does not match card with different rank' do
      expect(card1).not_to eq card4
    end

    it 'does not match card with different suit and rank' do
      expect(card1).not_to eq card5
    end
  end

  describe '#match' do
    let(:card1) { Cribbage::Card.new(7, :spades) }
    let(:card2) { Cribbage::Card.new(7, :clubs) }
    let(:card3) { Cribbage::Card.new(3, :diamonds) }
    let(:card4) { Cribbage::Card.new(7, :clubs) }
    let(:card5) { Cribbage::Card.new(:ace, :hearts) }
    let(:card6) { Cribbage::Card.new(1, :spades) }
    let(:card7) { Cribbage::Card.new(7, :hearts) }
    let(:card8) { Cribbage::Card.new(7, :diamons) }

    it 'matches a card of the same value' do
      expect(card1.match card2).to be_truthy
    end

    it 'does not match a card of a different value' do
      expect(card1.match card3).to be_falsey
    end

    it 'equals the same card' do
      expect(card1.match card4).to be_truthy
    end

    it '1 equals ace' do
      expect(card5.match card6).to be_truthy
    end

    it 'matches two cards of the same value' do
      expect(card1.match card2, card7).to be_truthy
    end

    it 'does not match two cards with one card of a different value' do
      expect(card1.match card2, card3).to be_falsey
    end

    it 'matches three cards of the same value' do
      expect(card1.match card2, card7, card8).to be_truthy
    end

    it 'does not match three cards with one card of a different value' do
      expect(card1.match card2, card3, card7).to be_falsey
    end
  end
end
