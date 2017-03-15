#! /usr/bin/ruby

#          w    h  q    d  n
$coins = [100, 50, 25, 10, 5]
load './coins.rb'

0.upto(4) { |w|
  0.upto(4-w) { |h|
    0.upto(4-w-h) { |q|
      0.upto(4-w-h-q) { |d|
        0.upto(4-w-h-q-d) { |n|
        #  n = 4-w-h-q-d
          x = [w,h,q,d,n]
          cs = CoinSet.new(x)
          puts "have length #{cs.length} with value #{cs.value}"
        }
      }
    }
  }
}
