require 'cribbage/deck'

class Cribbage
  DEAL = 0
  CRIB = 1
  STARTER = 2
  PLAY = 3
  SHOW = 4
  STAGES = [
    'The Deal',
    'The Crib',
    'The Starter',
    'The Play',
    'The Show'
  ]

  attr_reader :hand
  attr_reader :round
  attr_reader :starter
  attr_reader :score
  attr_reader :to_play

  def initialize
    @deck = Cribbage::Deck.new
    @stage = DEAL
    @round = 1
    @hand = [[], [], []]
    @score = [0, 0]
    @last_score = [0, 0]
    #@dealer = rand(2) # TODO Do this by cutting the deck

    # Cut for deal
    @initial_cut = []
    a = @deck[rand(52)]
    b = @deck[rand(52)]
    @initial_cut << [ a, b ]
    while a == b
      a = @deck[rand(52)]
      b = @deck[rand(52)]
      @initial_cut << [ a, b ]
    end
    @dealer = ( @initial_cut[-1][0] < @initial_cut[-1][1] ? 0 : 1 )
    @to_play = 1 - @dealer
    #@dealer = 1
  end

  def screen
    puts `clear`
    puts "Round: #{round}"
    puts "Dealer: #{@dealer + 1} (you are player 1)"
    puts "Stage: #{stage}"
    puts display_board
    puts
    if @starter
      puts "Starter:   -----\n"
      puts "          | %-2s  |\n" % @starter.short_rank
      puts "          |   %s |\n" % @starter.suit[0].upcase
      puts "           ----- \n"
      puts
    end
  end

  def display_board
    board = <<BOARD
              1     1     2     2     3     3     4     4     5     5     6
        5     0     5     0     5     0     5     0     5     0     5     0
BOARD

    lines = [
      "1 . ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....\n",
      "2 . ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....\n",
      "2 . ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....\n",
      "1 . ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... ..... .....\n"
    ]
    [0,1].each do |i|
      if @score[i] == 0 && @last_score[i] == 0
        lines[i][2] = 'o'
        lines[3-i][2] = 'o'
      else
        if @last_score[i] <= 60
          lines[i][2 + @last_score[i] + ((@last_score[i] + 4) / 5)] = 'o'
        end
        if @score[i] <= 60
          lines[i][2 + @score[i] + ((@score[i] + 4) / 5)] = 'o'
        end
      end
    end

    board += lines[0]
    board += lines[1]
    board += "\n"
    board += lines[2]
    board += lines[3]

    board += <<BOARD
    0     5     0     5     0     5     0     5     0     5     0     5
    2     1     1     0     0     9     9     8     8     7     7     6
BOARD

    board
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
      @hand = [[], [], []]
      6.times do
        @hand[1 - @dealer] << @deck.deal
        @hand[@dealer] << @deck.deal
      end
      @stage = CRIB
    when CRIB
      @starter = @deck.sample
      @score[@dealer] += 2 if @starter.rank == :jack
      @stage = STARTER
    when STARTER
      @stage = PLAY
    when PLAY
      @stage = SHOW
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

  def display_play
    h = <<PLAY
    -----
1: |     |
   |     |
    -----
    -----
2: |     |
   |     |
    -----
PLAY
  end

  def move_to_crib options
    p = options[:player]
    # From highest to lowest
    options[:cards].sort.reverse.each do |c|
      @hand[2] << @hand[p].delete_at(c-1)
    end
  end

  #def to_play
  #  1 - @dealer
  #end

  def play card
    if @hand[@to_play].include? card
      @to_play = 1 - @to_play
    else
      false
    end
  end
end
