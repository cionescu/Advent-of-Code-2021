# ruby solution.rb

require 'irb'

def part_1
  File.read('input_part1').split("\n").each_cons(2).count{ |items| items.first.to_i < items.last.to_i }
end

puts "Part1: #{part_1}"
