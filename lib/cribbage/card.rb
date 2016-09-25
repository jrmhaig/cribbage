class Cribbage
  class Card
    attr_reader :rank
    attr_reader :suit

    @@faces = {
      ace: 1,
      jack: 10,
      queen: 10,
      king: 10
    }

    def initialize value, suit
      @rank = ( value == 1 ? :ace : value )
      @suit = suit
    end

    def value
      @rank.is_a?(Integer) ? @rank : @@faces[@rank]
    end

    def match other1, other2 = nil, other3 = nil
      self.rank == other1.rank &&
        ( (! other2) || self.rank == other2.rank ) &&
        ( (! other3) || self.rank == other3.rank )
    end

    def == other
      self.rank == other.rank && self.suit == other.suit
    end

    def eql? other
      self == other
    end

    def hash
      (@suit.to_s + @rank.to_s).hash
    end
  end
end
