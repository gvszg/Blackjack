# Deal both player and dealer get two cards 
# set calculate all players cards value system
# check all players card value : if == 21 ,blackjack
# player phrase:if < 21, hit or stand repeat until value == or > 21
# dealer phrase:if < 17, hit until value == or > 21
# compare values

suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs'].shuffle
cards = ['2','3','4','5','6','7','8','9','10','A','J','Q','K'].shuffle

 # inital deal
player_hands = cards.sample(2)
dealer_hands = cards.sample(2)
 
# calculator total
def calculate_total(cards)
  arr = cards
  total = 0
  arr.each do |value|
    if value =='A'
      total += 11
    elsif value.to_i == 0
      total += 10
    else
      total += value.to_i
    end
end
  
# another Ace value
arr.select{|e| e == 'A'}.count.times do 
  total -= 10 if total > 21
  end
  
  total 
end

dealer_total = calculate_total(dealer_hands)
player_total = calculate_total(player_hands)

# on the deck
puts "---------------------------"
puts "Dealer: #{suits.sample}-#{dealer_hands[0]},#{suits.sample}-#{dealer_hands[1]}"
puts "        #{dealer_total} points "
puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts "Player: #{suits.sample}-#{player_hands[0]},#{suits.sample}-#{player_hands[1]}"
puts "        #{player_total} points "
puts "---------------------------"

# player action
if player_total == 21
  puts "Hit Blackjack!" 
  puts "*v* player won *v*"
  exit
end

while player_total < 21
  puts "Player would: 1.Hit or 2.Stand"
  player_do = gets.chomp.to_i
  
  if player_do == 2
    puts "Player Stand"
    puts "-----------------------"
  break
end

  # player hit
new_card = cards.sample
puts "Dealing card to player #{suits.sample}-#{new_card}"
player_hands << new_card
player_total = calculate_total(player_hands)
puts "Player total now: #{player_total}"
puts "--------------------------"
if player_total == 21
  puts "*v* Player won *v*"
  exit
elsif player_total > 21
  puts "Player Bust!"
  puts "Good Luck!"
  exit
end
end

# dealer action
if dealer_total == 21
  puts "Dealer hit Blackjack, player lose!"
  exit
end

while dealer_total < 17
  new_card = cards.sample
  puts "Dealing card to dealer #{suits.sample}-#{new_card}"
  dealer_hands << new_card
  dealer_total = calculate_total(dealer_hands)
  puts "Dealer total now: #{dealer_total}"
  puts "-------------------------"

  if dealer_total == 21
    puts "ooohh...Dealer won!?"
    exit
  elsif dealer_total > 21
    puts "Lucky! Dealer Bust!"
    puts "*v* Player won *v*"
    exit
  end
end 

# display final
puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts "Dealer's cards:" 
dealer_hands.each do |card|
  puts "#{suits.sample}-#{card}"
end
puts "points: #{dealer_total}"
puts "==========================="
puts "Player's cards:"
player_hands.each do |card|
  puts "#{suits.sample}-#{card}"
end
puts "points: #{player_total}"
puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~"

if dealer_total < player_total
  puts "*v* Player won *v*"
elsif dealer_total > player_total
  puts "ooohh...Dealer won!?"
else
  puts "<=P`U`S`H=>"
end

exit
