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

    describe '#proceed' do
      it 'moves from crib to starter' do
        expect{cribbage.proceed}.to change(cribbage, :stage).from('The Crib').to('The Starter')
      end

      it 'remains on round 1 when moving to the next stage' do
        expect{cribbage.proceed}.to change(cribbage, :round).by 0
      end

      it 'sets the starter' do
        expect{cribbage.proceed}.to change(cribbage, :starter).from(NilClass).to Cribbage::Card
      end

      context 'all jacks' do
        # Rig the deck
        let(:rigged_deck) { Cribbage::Deck[
          Cribbage::Card.new(:jack, :spades),
          Cribbage::Card.new(:jack, :hearts),
          Cribbage::Card.new(:jack, :diamonds),
          Cribbage::Card.new(:jack, :clubs)
        ] }

        before(:each) do
          cribbage.instance_variable_set(:@deck, rigged_deck)
        end

        it 'scores two for his heels for player 1' do
          cribbage.instance_variable_set(:@dealer, 0)
          # Would be nice to be able to do this by 'change'
          s1 = cribbage.score[0]
          s2 = cribbage.score[1]
          cribbage.proceed
          expect(cribbage.score[0]).to eq s1 + 2
          expect(cribbage.score[1]).to eq s2
        end

        it 'scores two for his heels for player 2' do
          cribbage.instance_variable_set(:@dealer, 1)
          # Would be nice to be able to do this by 'change'
          s1 = cribbage.score[0]
          s2 = cribbage.score[1]
          cribbage.proceed
          expect(cribbage.score[0]).to eq s1
          expect(cribbage.score[1]).to eq s2 + 2
        end
      end

      context 'no jacks' do
        # Rig the deck
        let(:rigged_deck) { Cribbage::Deck[
          Cribbage::Card.new(2, :spades),
          Cribbage::Card.new(4, :hearts),
          Cribbage::Card.new(5, :diamonds),
          Cribbage::Card.new(6, :clubs)
        ] }


        before(:each) do
          cribbage.instance_variable_set(:@deck, rigged_deck)
        end

        it 'does not score for player 1' do
          cribbage.instance_variable_set(:@dealer, 0)
          # Would be nice to be able to do this by 'change'
          s1 = cribbage.score[0]
          s2 = cribbage.score[1]
          cribbage.proceed
          expect(cribbage.score[0]).to eq s1
          expect(cribbage.score[1]).to eq s2
        end

        it 'does not score for player 2' do
          cribbage.instance_variable_set(:@dealer, 1)
          # Would be nice to be able to do this by 'change'
          s1 = cribbage.score[0]
          s2 = cribbage.score[1]
          cribbage.proceed
          expect(cribbage.score[0]).to eq s1
          expect(cribbage.score[1]).to eq s2
        end
      end
    end
  end

  context 'at the starter' do
    let(:cribbage) { Cribbage.new }

    before(:each) do
      cribbage.proceed
      cribbage.proceed
    end

    describe '#proceed' do
      it 'moves from crib to starter' do
        expect{cribbage.proceed}.to change(cribbage, :stage).from('The Starter').to('The Play')
      end
    end
  end

  context 'at the play' do
    let(:cribbage) { Cribbage.new }

    before(:each) do
      cribbage.proceed
      cribbage.proceed
      cribbage.proceed
    end

    describe '#proceed' do
      it 'moves from play to play' do
        expect{cribbage.proceed}.to change(cribbage, :stage).from('The Play').to('The Show')
      end
    end

    describe '#play' do
      context 'turn of player 2' do
        before(:each) do
          cribbage.instance_variable_set(:@to_play, 1)
        end

        it 'makes it the turn of player 1' do
          expect{cribbage.play(cribbage.hand[1].sample)}.to change(cribbage, :to_play).from(1).to 0
        end

        it 'fails with an invalid card' do
          expect(cribbage.play(cribbage.hand[0].sample)).to be_falsey
        end

        it 'does not change to player 1 with invalid card' do
          expect{cribbage.play(cribbage.hand[0].sample)}.not_to change(cribbage, :to_play)
        end
      end
    end
  end

  context 'set the dealing player' do
    let(:cribbage) { Cribbage.new }
    let(:first_card) { cribbage.instance_variable_get(:@deck)[0] }
    let(:second_card) { cribbage.instance_variable_get(:@deck)[1] }

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
        ],
        []
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

  describe '#move_to_crib' do
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
        ],
        []
      ])
    end

    it 'removes cards from the first players hand' do
      expect{cribbage.move_to_crib(player: 0, cards: [2,3])}.to change(cribbage.hand[0], :length).by -2
    end

    it 'removes cards from the second players hand' do
      expect{cribbage.move_to_crib(player: 1, cards: [2,3])}.to change(cribbage.hand[1], :length).by -2
    end

    it 'removes the 10 of clubs and jack of hearts from the first players hand' do
      cribbage.move_to_crib(player: 0, cards: [4,5])
      # Note, the includes matcher uses the include? method, which uses ==
      [Cribbage::Card.new(10, :clubs), Cribbage::Card.new(:jack, :hearts)].each do |c|
        expect(cribbage.hand[0].index{ |a| a.eql? c }).to be_nil
      end
    end

    it 'removes the 5 of hearts and queen of diamonds from the second players hand' do
      cribbage.move_to_crib(player: 1, cards: [3,5])
      # Note, the includes matcher uses the include? method, which uses ==
      [Cribbage::Card.new(5, :hearts), Cribbage::Card.new(:queen, :diamonds)].each do |c|
        expect(cribbage.hand[1].index{ |a| a.eql? c }).to be_nil
      end
    end

    it 'adds the first players cards to the crib' do
      expect{cribbage.move_to_crib(player: 0, cards: [2,3])}.to change(cribbage.hand[2], :length).by 2
    end

    it 'adds the 10 of clubs and jack of hearts from the first players hand to the crib' do
      cribbage.move_to_crib(player: 0, cards: [4,5])
      # Note, the includes matcher uses the include? method, which uses ==
      [Cribbage::Card.new(10, :clubs), Cribbage::Card.new(:jack, :hearts)].each do |c|
        expect(cribbage.hand[2].index{ |a| a.eql? c }).not_to be_nil
      end
    end

    it 'adds the second players cards to the crib' do
      expect{cribbage.move_to_crib(player: 1, cards: [2,3])}.to change(cribbage.hand[2], :length).by 2
    end

    it 'adds the 5 of hearts and queen of diamonds from the second players hand to the crib' do
      cribbage.move_to_crib(player: 1, cards: [3,5])
      # Note, the includes matcher uses the include? method, which uses ==
      [Cribbage::Card.new(5, :hearts), Cribbage::Card.new(:queen, :diamonds)].each do |c|
        expect(cribbage.hand[2].index{ |a| a.eql? c }).not_to be_nil
      end
    end
  end

  describe '#display_board' do
    let(:cribbage) { Cribbage.new }

    it 'displays the board with zero score' do
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

    it 'displays the board with the score 10, 25 with the previous score 8, 16' do
      cribbage.instance_variable_set(:@score, [10, 25])
      cribbage.instance_variable_set(:@last_score, [8, 16])
      expect(cribbage.display_board).to eq <<BOARD
              1     1     2     2     3     3     4     4     5     5     6
        5     0     5     0     5     0     5     0     5     0     5     0
1 . ..... ..o.o ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
2 . ..... ..... ..... o.... ....o ..... ..... ..... ..... ..... ..... .....

2 . ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
1 . ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....
    0     5     0     5     0     5     0     5     0     5     0     5
    2     1     1     0     0     9     9     8     8     7     7     6
BOARD
    end
  end
end
