# ruby solution.rb

require 'irb'

def solution days: 256
  population = File.read('input').strip.split(',').map(&:to_i)

  initial_state = (0..8).to_a.map{ |item| population.count(item) }

  (1..days).inject(initial_state) do |acc, day|
    # puts "Day: #{day - 1} | #{acc.sum}"

    (0..8).to_a.map do |item|
      case item
      when 0..5, 7
        acc[item + 1]
      when 6
        acc[item + 1] + acc[0]
      when 8
        acc[0]
      end
    end

  end.sum

end

puts solution
