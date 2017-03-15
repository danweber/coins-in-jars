#! /usr/bin/ruby

require 'set'
load './coins.rb'

def get_smallest_set_for_prices(input)
#  p input
  values = []
  input.each { |v|
    vals = coins($coins, 4, v)
#    print "v is #{v}, vals is #{vals.to_s}\n"
    if vals.empty?
      puts "empty findings for #{v}, returning 20"
      return [5] * 20
    end
    values << vals
  }
#  pp values
  result3 = CoinSet.find_minimum_from_N_sets(*values)
  return result3
end

def get_main_values(n)
  # index from 1. n=1 means price is 3, C1 is 5, C2 is 10.
  return [-5 + 10 * n, -5 + 15 * n]
end

# OPTIIMIZATION: there is no set of 4 coins that matches these
$no_coins = [ 190, 195, 240, 245, 265, 270, 280, 285, 290, 295, 315, 320, 330, 335, 340, 345, 355, 360, 365, 370, 375, 380, 385, 390, 395, 405, 410, 415, 420, 425, 430, 435, 440, 445]

def test_combo(combo)
  puts "combo is #{combo.to_s}"
  prices = Set.new
  sum = 0
  combo.each { |c|
    temp = get_main_values(c)
#    puts "prices for #{c} is #{prices}"
    if $no_coins.include?(temp[0]) || $no_coins.include?(temp[1])
      puts "Value #{c}, which is of #{c*5-2} cents, includes #{temp}, at least one of which has no 4-coin solutions. Failing now."
      puts "rejecting answer"
      return 20
    end
    prices |= temp
    sum += (c*5 -2)
  }
#  puts "and sum is #{sum}"
  prices << sum
#  puts "set is #{prices.to_a}"
  answer = get_smallest_set_for_prices(prices)
  puts "answer is #{answer.length}, #{answer}"
  answer.length
end




values = []
values << coins($coins, 4, 5)
values << coins($coins, 4, 15)
values << coins($coins, 4, 25)
values << coins($coins, 4, 35)
values << coins($coins, 4, 45)
#values << coins($coins, 4, 55)

values << coins($coins, 4, 10)
values << coins($coins, 4, 25)
values << coins($coins, 4, 40)
values << coins($coins, 4, 55)
values << coins($coins, 4, 70)
#values << coins($coins, 4, 85)


values << coins($coins, 4, 65)
#values << coins($coins, 4, 70)


result3 = CoinSet.find_minimum_from_N_sets(*values)
puts "result3 is"
puts result3
puts "length is #{result3.length}"

list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
#list = [5,6,7,8,9,10]
#list = [6,7,8,9,10]

list =  [3, 4, 8, 27,  30, 33 ]
list = [1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,21,22];
combos = list.combination(5).to_a
# bads are 13,18,19,20, 23+


#array = [55, 85, 65, 100, 75, 115, 130, 95, 145, 190]
#answer = get_smallest_set_for_prices(array)
#puts "answer is #{answer}"

#exit

puts "XXX"
puts
pp combos.length
puts "YYY"
combos.each { |combo|
  res = test_combo(combo)
  exit if (res <= 4)
  puts
}
