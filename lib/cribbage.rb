require 'cribbage/deck'

class Cribbage
  DEAL = 0
  CRIB = 1
  #STARTER = 2
  #PLAY = 3
  #SHOW = 4
  STAGES = [
    'The Deal',
    'The Crib'
  ]

  attr_reader :hand
  attr_reader :round

  def initialize
    @deck = Cribbage::Deck.new
    @stage = DEAL
    @round = 1
    @hand = [[], []]
    #@dealer = rand(2) # TODO Do this by cutting the deck

    # Cut for deal
    @initial_cut = []
    a = @deck.cards[rand(52)]
    b = @deck.cards[rand(52)]
    @initial_cut << [ a, b ]
    while a == b
      a = @deck.cards[rand(52)]
      b = @deck.cards[rand(52)]
      @initial_cut << [ a, b ]
    end
    @dealer = ( @initial_cut[-1][0] < @initial_cut[-1][1] ? 0 : 1 )
    #@dealer = 1
  end

  def display_board
    <<BOARD
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

  def display_initial_cut
    display = <<CUT
Player 1 | Player 2
=========+=========
CUT
    @initial_cut.each do |pair|
      display += "  -----  |  -----\n"
      display += " | %-2s  | | | %-2s  |\n" % pair.map{ |c| c.short_rank }
      display += " |   %s | | |   %s |\n" % pair.map{ |c| c.suit[0].upcase }
      display += "  -----  |  -----\n"
    end

    display + "\nPlayer #{@dealer+1} to deal\n"
  end

  def stage
    STAGES[@stage]
  end

  def proceed
    case @stage
    when DEAL
      @hand = [[], []]
      6.times do
        @hand[1 - @dealer] << @deck.deal
        @hand[@dealer] << @deck.deal
      end
      @stage = CRIB
    end
  end

  def display_hand player
    values = []
    suits = [] 
    count = []
    @hand[player].each do |c|
      values << "| %-2s  |" % c.short_rank
      suits << "|   %s |" % c.suit[0].upcase
      count << values.length # Must be easier way than this
    end

    h = ([" ----- "] * @hand[player].count).join(' ') + "\n"
    h += values.join(' ') + "\n"
    h += suits.join(' ') + "\n"
    h += ([" ----- "] * @hand[player].count).join(' ') + "\n"
    h += '   ' + count.join('       ') + "\n"
    h
  end
end
