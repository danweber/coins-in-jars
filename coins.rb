#! /usr/bin/ruby




require 'pp'

$debug = nil
$coins = [100, 50, 25, 10, 5]
#$coins = [100, 50]
# $coins = [10, 5]
$limit = 4

class CoinSet
  attr_accessor :dollars, :halves, :quarters, :dimes, :nickels, :array
  def initialize(input_array)
    raise "failure, wrong length, #{input_array}" unless input_array.length == 5
    array = input_array.dup
    @dollars = input_array[0]
    @halves  = input_array[1]
    @quarters= input_array[2]
    @dimes   = input_array[3]
    @nickels = input_array[4]
  end

  def to_s
    str = []
    str << "#{@dollars} 100c" if @dollars > 0
    str << "#{@halves} 50c"  if @halves > 0
    str << "#{@quarters} 25c" if @quarters > 0
    str << "#{@dimes} 10c" if @dimes > 0
    str << "#{@nickels} 5c" if @nickels > 0
    str.join(", ")
  end

  def value
    return 100 * @dollars + 50 * @halves + 25 * @quarters + 10 * @dimes + 5 * @nickels
  end
  
  def length
    count
  end
  
  def count
    return @dollars + @halves + @quarters + @dimes + @nickels
  end

  def self.merge(a, b)
    array = [
      [a.dollars, b.dollars].max,
      [a.halves, b.halves].max,
      [a.quarters, b.quarters].max,
      [a.dimes, b.dimes].max,
      [a.nickels, b.nickels].max
    ]
    return new(array)
  end

  def self.from_two(a, b)
    raise "size" unless a.length == 5 && b.length == 5
    array = []
    0.upto(4) { |n|
      array[n] = [a[n], b[n]].max
    }
    return new(array)
  end

  def self.from_N(*sets)
    input = *sets
    input.each { |array| 
      raise "size" unless array.length == 5
    }
    array = []
    0.upto(4) { |n|
      max = 0;
      input.each { |array|
        max = array[n] if array[n] > max
      }
      array << max
    }
    return new(array)
  end

  def self.find_minimum_from_pair_of_sets(aa,bb)
    min_length = 99999
    result = []
    
    aa.each { |a|
      bb.each { |b|
        cs = CoinSet.from_two(a,b)
        result = cs if (cs.length) < min_length
      }
    }
    result
  end

  def self.all_combinations(*sets)
    input = *sets;
    prod = sets.inject(1) { |p,a| p * a.length } 
    prod.times { |p|
      args = []
      index = p
      input.each { |array|
        quotient = index  / array.length # /**/
        remainder = index % array.length
        args << array[remainder]
        index = quotient
      }
      pp args
    }
  end
    
    
  
  def self.find_minimum_from_N_sets(*sets)
    input = *sets;

    min_length = 99999
    result = [ ]
    
    prod = 1;
    input.each { |array|
      prod *= array.length;
    }
    puts prod
    prod.times { |p|
      args = []
      index = p
 #     puts "p is #{p}, index is #{index}"
      input.each { |array|
        quotient = index  / array.length # /* */
        remainder = index % array.length
        args << array[remainder]
        index = quotient
#        puts "after #{array.length}, quotient is #{quotient} and index is #{index}"
      }
      cs = CoinSet.from_N(*args)
      result = cs if (cs.length) < min_length
    }
    result
  end


end



def coins(coins, count, value)
#  puts "..... coins is #{coins}"
  ret = [ ]
  # done
  return ret if count.zero? || coins.empty?
  # this coin is too big
  # return coins(coins.drop(1), count, value) if coins[0] > value
  #
  this_value = coins[0]
#  puts "this_value is #{this_value}"
  
  if coins.length == 1
    # return whatever value is left, as long as it fits. Assume no fractions here
    c = value / this_value
    if (c <= count)
      return [ [c] ]
#      return [ ["#{c} of #{this_value}c"] ]
    else
      return ret
    end
  end

  0.upto(count) { |n|
    p "#{n} of #{count}, #{this_value}c" if $debug
    if n * this_value == value
#      puts "************************"
      val = ["#{n} of #{this_value}c", * coins(coins.drop(1), 0, 0) ]
      val = [n] + [0] * (coins.length - 1)
      ret << val
      next
    end
    if n * this_value > value
      break
    end
    sub = coins(coins.drop(1), count - n, value - n * this_value)
    if $debug
      p "at #{this_value}, got #{sub.count} arrays..."
      p "<<"
      pp sub
      p ">>"
    end
    sub.each { |s|
      new_answer = ["#{n} of #{this_value}c"].concat(s)
      new_answer = [n] + s
#      puts "passing up new answer, #{new_answer}"
      ret << new_answer
    }
  }
  ret
end
