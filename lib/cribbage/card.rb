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

    @@face_rank = {
      ace: 1,
      jack: 11,
      queen: 12,
      king: 13
    }

    def initialize value, suit
      @rank = ( value == 1 ? :ace : value )
      @suit = suit
    end

    def value(full_value = false)
      if full_value
        @rank.is_a?(Integer) ? @rank : @@face_rank[@rank]
      else
        @rank.is_a?(Integer) ? @rank : @@faces[@rank]
      end
    end

    def match other1, other2 = nil, other3 = nil
      self.rank == other1.rank &&
        ( (! other2) || self.rank == other2.rank ) &&
        ( (! other3) || self.rank == other3.rank )
    end

    # Equal card value
    def == other
      self.rank == other.rank
    end

    # Identical card
    def eql? other
      self.rank == other.rank && self.suit == other.suit
    end

    def < other
      self.value(true) < other.value(true)
    end

    def > other
      self.value(true) > other.value(true)
    end

    def hash
      (@suit.to_s + @rank.to_s).hash
    end

    def short_rank
      @rank.is_a?(Integer) ? @rank.to_s : @rank.to_s[0].upcase
    end
  end
end
