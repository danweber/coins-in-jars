#! /usr/bin/ruby

require 'set'
load './coins.rb'

$max_bad_answer = 20

def get_smallest_set_for_prices(input)
  values = []
  input.each { |v|
    vals = coins($coins, 4, v)
    if vals.empty?
      puts "empty findings for #{v}, returning 20"
      return [5] * $max_bad_answer
    end
    values << vals
  }
  CoinSet.find_minimum_from_N_sets(*values)
end

def get_main_values(n)
  # index from 1. n=1 means price is 3, C1 is 5, C2 is 10.
  return [-5 + 10 * n, -5 + 15 * n]
end

# OPTIIMIZATION: there is no set of 4 coins that matches these, so we can end them on sight.
$no_coins = [ 190, 195, 240, 245, 265, 270, 280, 285, 290, 295, 315, 320, 330, 335, 340, 345, 355, 360, 365, 370, 375, 380, 385, 390, 395, 405, 410, 415, 420, 425, 430, 435, 440, 445]

def test_combo(combo)
  puts "combo is #{combo.to_s}"
  prices = Set.new
  sum = 0
  combo.each { |c|
    temp = get_main_values(c)
    if $no_coins.include?(temp[0]) || $no_coins.include?(temp[1])
      puts "Value #{c}, which is of #{c*5-2} cents, includes #{temp}, at least one of which has no 4-coin solutions. Failing now."
      puts "rejecting answer"
      return $max_bad_answer
    end
    prices |= temp
    sum += (c*5 -2)
  }
  prices << sum
  answer = get_smallest_set_for_prices(prices)
  puts "answer is #{answer.length}, #{answer}"
  answer.length
end

if :test_condition_one
  values = []
  values << coins($coins, 4, 5)
  values << coins($coins, 4, 15)
  values << coins($coins, 4, 25)
  values << coins($coins, 4, 35)
  values << coins($coins, 4, 45)

  values << coins($coins, 4, 10)
  values << coins($coins, 4, 25)
  values << coins($coins, 4, 40)
  values << coins($coins, 4, 55)
  values << coins($coins, 4, 70)

  values << coins($coins, 4, 65)

  result3 = CoinSet.find_minimum_from_N_sets(*values)
  puts "result3 is"
  puts result3
  puts "length is #{result3.length}"
end

# bads are 13,18,19,20, 23+. Those can never have 4 coins because of either C1 or C2.
# To try something easier, try list = [1,2,3,4,5,6,7];
list = [1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,21,22];
combos = list.combination(5).to_a

puts
puts "Searching #{combos.length} combinations . . ."

combos.each { |combo|
  res = test_combo(combo)
  exit if (res <= 4)
  puts
}
