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
      total -= 10 if total > Blackjack::BLACKJACK_AMOUNT
    end
  
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def show_flop
    show_hand
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

  def show_flop
    puts "----- Dealer's Hand -----"
    puts "First card is hidden"
    puts "Second card is #{cards[1]}"
  end
end

class Blackjack
  attr_accessor :deck, :player
  attr_reader :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("name")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sory, dealer hits blackjack. #{player.name} loses!"
      else
        puts "Congratulations, you hit blackjack! #{player.name} wins!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Lucky, dealer busted. #{player.name} win!"
      else
        puts "Sorry, It busted. #{player.name} loses!" 
      end
      play_again?
    end
  end

  def player_turn
    puts "-------------------------"
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "What would you like to do? (1)hit (2)stay"
      response = gets.chomp

      if !['1', '2'].include?(response)
        puts "Please enter 1 or 2 !"
        next
      end

      if response == '2'
        puts "#{player.name} chose to stay."
        break
      end

      new_card = deck.deal_one
      puts "Dealing #{new_card} to #{player.name}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"
      puts "-------------------------"

      blackjack_or_bust?(player)
    end

    puts "#{player.name} stays at #{player.total}."
    puts "-------------------------"
  end

  def dealer_turn
    puts "-------------------------"
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)

    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing #{new_card} to dealer"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}"
      puts "-------------------------"

      blackjack_or_bust?(dealer)     
    end

    puts "Dealer stays at #{dealer.total}."
    puts "-------------------------"
  end

  def who_won?
    if player.total > dealer.total
      puts "Congratulations, #{player.name} wins!"
    elsif player.total < dealer.total 
      puts "Sorry, #{player.name} loses!"
    else
      puts "PUSH!"
    end
    play_again?
  end

  def play_again?
    puts "Would you like to play again? (1)yes (2)exit"
    
    if gets.chomp == '1'
      puts "New game starting..."
      game_reset
      start
    else 
      puts "Have Fun!"
      puts "Good Bye!"
      exit
    end    
  end

  def game_reset
    deck = Deck.new 
    player.cards = []
    dealer.cards = []   
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end


game = Blackjack.new
game.start
