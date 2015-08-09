require 'pry'

class Card
  attr_accessor :suit, :paper_number
  
  def initialize(suit, paper_number)
    @suit = suit
    @paper_number = paper_number
  end

  def card_output
    "The card : #{paper_number} - #{suit_display}"
  end

  def to_s
    card_output
  end

  def suit_display
    case suit
    when 'S' then 'Spades'
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'C' then 'Clubs'
    end
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    %w[S H D C].each do |suit|
      %w[2 3 4 5 6 7 8 9 10 A J K Q].each do |paper_number|
        @cards << Card.new(suit, paper_number)
      end
    end

    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "----- #{name}'s Hand -----"
    cards.each do |card|
      puts "#{card}"
    end
    puts "Total : #{total}"
  end

  def total
    paper_numbers = cards.map{|card| card.paper_number}
    total = 0

    paper_numbers.each do |val|
      if val == 'A'
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    paper_numbers.select{|val| val == 'A'}.count.times do 
      total -= 10 if total > 21
    end
  
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer
  include Hand

  attr_accessor :cards
  attr_reader :name

  def initialize
    @name = "Dealer"
    @cards = []
  end

end


deck = Deck.new

player = Player.new("AJ")
player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.show_hand
player.total

dealer = Dealer.new
dealer.add_card(deck.deal_one)
dealer.add_card(deck.deal_one)
dealer.add_card(deck.deal_one)
dealer.show_hand
dealer.total
