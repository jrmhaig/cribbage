require 'cribbage'

RSpec.describe Cribbage do
  context 'at the start of the game' do
    let(:cribbage) { Cribbage.new }

    describe '#display_board' do
      it 'displays the initial board' do
        expect(cribbage.display_board).to eq <<BOARD
              1     1     2     2     3     3     4     4     5     5     6
        5     0     5     0     5     0     5     0     5     0     5     0
1 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
2 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....

2 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
1 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
    0     5     0     5     0     5     0     5     0     5     0     5
    2     1     1     0     0     9     9     8     8     7     7     6
BOARD
      end
    end

    describe '#stage' do
      it 'starts the game at the deal' do
        expect(cribbage.stage).to eq 'The Deal'
      end
    end

    describe '#round' do
      it 'starts the game at round 1' do
        expect(cribbage.round).to eq 1
      end
    end

    describe '#proceed' do
      it 'moves from deal to crib' do
        expect{cribbage.proceed}.to change(cribbage, :stage).from('The Deal').to('The Crib')
      end

      it 'remains on round 1 when moving to the next stage' do
        expect{cribbage.proceed}.to change(cribbage, :round).by 0
      end
    end
  end

  context 'at the crib' do
    let(:cribbage) { Cribbage.new }

    before(:each) do
      cribbage.proceed
    end

    describe '#display_board' do
      it 'displays the board after the deal' do
        expect(cribbage.display_board).to eq <<BOARD
              1     1     2     2     3     3     4     4     5     5     6
        5     0     5     0     5     0     5     0     5     0     5     0
1 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
2 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....

2 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
1 o ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
    0     5     0     5     0     5     0     5     0     5     0     5
    2     1     1     0     0     9     9     8     8     7     7     6
BOARD
      end
    end

    describe '#hand' do
      it 'has six items in the first players hand' do
        expect(cribbage.hand[0].length).to eq 6
      end

      it 'has six cards in the first players hand' do
        cribbage.hand[0].each do |card|
          expect(card).to be_a Cribbage::Card
        end
      end

      it 'has six different cards in the first players hand' do
        expect(cribbage.hand[0].uniq.length).to eq 6
      end

      it 'has six items in the second players hand' do
        expect(cribbage.hand[1].length).to eq 6
      end

      it 'has six cards in the second players hand' do
        cribbage.hand[1].each do |card|
          expect(card).to be_a Cribbage::Card
        end
      end

      it 'has six different cards in the second players hand' do
        expect(cribbage.hand[1].uniq.length).to eq 6
      end
    end
  end

  context 'set the dealing player' do
    let(:cribbage) { Cribbage.new }
    let(:first_card) { cribbage.instance_variable_get(:@deck).cards[0] }
    let(:second_card) { cribbage.instance_variable_get(:@deck).cards[1] }

    context 'at the crib with player one dealing' do
      before(:each) do
        first_card
        second_card
        cribbage.instance_variable_set(:@dealer, 0)
        cribbage.proceed
      end

      describe '#hand' do
        it 'gives the first card to player two' do
          expect(cribbage.hand[1]).to include first_card
        end

        it 'gives the second card to player one' do
          expect(cribbage.hand[0]).to include second_card
        end
      end
    end

    context 'at the crib with player two dealing' do
      before(:each) do
        first_card
        second_card
        cribbage.instance_variable_set(:@dealer, 1)
        cribbage.proceed
      end

      describe '#hand' do
        it 'gives the first card to player one' do
          expect(cribbage.hand[0]).to include first_card
        end

        it 'gives the second card to player two' do
          expect(cribbage.hand[1]).to include second_card
        end
      end
    end
  end

  describe '#display_hand' do
    let(:cribbage) { Cribbage.new }

    before(:each) do
      cribbage.instance_variable_set(:@hand, [
        [
          Cribbage::Card.new(2, :hearts),
          Cribbage::Card.new(3, :spades),
          Cribbage::Card.new(5, :spades),
          Cribbage::Card.new(10, :clubs),
          Cribbage::Card.new(:jack, :hearts),
          Cribbage::Card.new(:king, :diamonds)
        ],
        [
          Cribbage::Card.new(5, :clubs),
          Cribbage::Card.new(5, :spades),
          Cribbage::Card.new(5, :hearts),
          Cribbage::Card.new(:ace, :clubs),
          Cribbage::Card.new(:queen, :diamonds),
          Cribbage::Card.new(5, :diamonds)
        ]
      ])
    end

    it 'displays the first players hand' do
      expect(cribbage.display_hand(0)).to eq <<HAND
 -----   -----   -----   -----   -----   ----- 
| 2   | | 3   | | 5   | | 10  | | J   | | K   |
|   H | |   S | |   S | |   C | |   H | |   D |
 -----   -----   -----   -----   -----   ----- 
   1       2       3       4       5       6
HAND
    end

    it 'displays the second players hand' do
      # TODO Should this be ordered?
      expect(cribbage.display_hand(1)).to eq <<HAND
 -----   -----   -----   -----   -----   ----- 
| 5   | | 5   | | 5   | | A   | | Q   | | 5   |
|   C | |   S | |   H | |   C | |   D | |   D |
 -----   -----   -----   -----   -----   ----- 
   1       2       3       4       5       6
HAND
    end
  end
end
