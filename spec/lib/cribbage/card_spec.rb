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

    it 'matches cards of the same rank' do
      expect(card1).to eq card3
    end

    it 'does not match card with different rank' do
      expect(card1).not_to eq card4
    end

    it 'does not match card with different suit and rank' do
      expect(card1).not_to eq card5
    end
  end

  describe '#<' do
    let(:card1) { Cribbage::Card.new(7, :spades) }
    let(:card2) { Cribbage::Card.new(6, :spades) }
    let(:card3) { Cribbage::Card.new(6, :hearts) }
    let(:card4) { Cribbage::Card.new(8, :spades) }
    let(:card5) { Cribbage::Card.new(8, :diamonds) }
    let(:card6) { Cribbage::Card.new(7, :diamonds) }

    it 'identifies 6S < 7S' do
      expect(card2).to be < card1
    end

    it 'identifies 6H < 7S' do
      expect(card3).to be < card1
    end

    it 'identifies ! ( 8S < 7S )' do
      expect(card4).not_to be < card1
    end

    it 'identifies ! ( 8D < 7S )' do
      expect(card5).not_to be < card1
    end

    it 'identifies ! ( 7S < 7S )' do
      expect(card1).not_to be < card1
    end

    it 'identifies ! ( 7D < 7S )' do
      expect(card6).not_to be < card1
    end

    it 'ace is lower than a number' do
      expect(Cribbage::Card.new(:ace, :spaces)).to be < Cribbage::Card.new(5, :diamonds)
    end

    it 'number is not lower than an ace' do
      expect(Cribbage::Card.new(5, :spaces)).not_to be < Cribbage::Card.new(:ace, :diamonds)
    end

    it 'number is lower than a jack' do
      expect(Cribbage::Card.new(6, :spaces)).to be < Cribbage::Card.new(:jack, :diamonds)
    end

    it 'jack is not lower than a number' do
      expect(Cribbage::Card.new(:jack, :spaces)).not_to be < Cribbage::Card.new(6, :diamonds)
    end

    it 'jack is lower than a queen' do
      expect(Cribbage::Card.new(:jack, :spaces)).to be < Cribbage::Card.new(:queen, :diamonds)
    end

    it 'queen is lower than a king' do
      expect(Cribbage::Card.new(:jack, :spaces)).to be < Cribbage::Card.new(:queen, :diamonds)
    end
  end

  describe '#>' do
    let(:card1) { Cribbage::Card.new(7, :spades) }
    let(:card2) { Cribbage::Card.new(6, :spades) }
    let(:card3) { Cribbage::Card.new(6, :hearts) }
    let(:card4) { Cribbage::Card.new(8, :spades) }
    let(:card5) { Cribbage::Card.new(8, :diamonds) }
    let(:card6) { Cribbage::Card.new(7, :diamonds) }

    it 'identifies ! ( 6S > 7S )' do
      expect(card2).not_to be > card1
    end

    it 'identifies ! ( 6H > 7S )' do
      expect(card3).not_to be > card1
    end

    it 'identifies 8S > 7S' do
      expect(card4).to be > card1
    end

    it 'identifies 8D > 7S' do
      expect(card5).to be > card1
    end

    it 'identifies ! ( 7S > 7S )' do
      expect(card1).not_to be > card1
    end

    it 'identifies ! ( 7D > 7S )' do
      expect(card6).not_to be > card1
    end

    it 'ace is not higher than a number' do
      expect(Cribbage::Card.new(:ace, :spaces)).not_to be > Cribbage::Card.new(5, :diamonds)
    end

    it 'number is higher than an ace' do
      expect(Cribbage::Card.new(5, :spaces)).to be > Cribbage::Card.new(:ace, :diamonds)
    end

    it 'number is not higher than a jack' do
      expect(Cribbage::Card.new(6, :spaces)).not_to be > Cribbage::Card.new(:jack, :diamonds)
    end

    it 'jack is higher than a number' do
      expect(Cribbage::Card.new(:jack, :spaces)).to be > Cribbage::Card.new(6, :diamonds)
    end

    it 'king is higher than a queen' do
      expect(Cribbage::Card.new(:king, :spaces)).to be > Cribbage::Card.new(:queen, :diamonds)
    end

    it 'queen is higher than a jack' do
      expect(Cribbage::Card.new(:queen, :spaces)).to be > Cribbage::Card.new(:jack, :diamonds)
    end
  end

  describe '#eql?' do
    let(:card1) { Cribbage::Card.new(7, :spades) }
    let(:card2) { Cribbage::Card.new(7, :spades) }
    let(:card3) { Cribbage::Card.new(7, :hearts) }
    let(:card4) { Cribbage::Card.new(3, :spades) }
    let(:card5) { Cribbage::Card.new(:king, :diamonds) }

    it 'matches identical cards' do
      expect(card1).to eql card2
    end

    it 'does not match a card of a different suit' do
      expect(card1).not_to eql card3
    end

    it 'does not match card with different rank' do
      expect(card1).not_to eql card4
    end

    it 'does not match card with different suit and rank' do
      expect(card1).not_to eql card5
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

  describe '#short_rank' do
    it 'returns the value of a number card' do
      (2..10).each do |n|
        expect(Cribbage::Card.new(n, :spades).short_rank).to eq n.to_s
      end
    end

    it 'returns the initial of a face card' do
      expect(Cribbage::Card.new(:ace, :spades).short_rank).to eq 'A'
      expect(Cribbage::Card.new(:jack, :spades).short_rank).to eq 'J'
      expect(Cribbage::Card.new(:queen, :spades).short_rank).to eq 'Q'
      expect(Cribbage::Card.new(:king, :spades).short_rank).to eq 'K'
    end

  end
end
