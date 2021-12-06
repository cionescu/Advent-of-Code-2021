# ruby solution.rb

require 'irb'

class Item
  attr_accessor :value, :checked

  def initialize value, checked = false
    @value = value.to_i
    @checked = checked
  end

  def selected! number
    if number == value
      self.checked = true
    end
  end

  def checked?
    checked
  end

  def unchecked?
    !checked?
  end

  def to_s
    "#{value}#{checked? ? '✔️' : '-'}"
  end
  alias inspect to_s
end

class Matrix
  attr_accessor :rows, :column_count, :completed

  def initialize rows = [], column_count = 0
    @rows = []
    @column_count = 0
    @completed = false
  end

  def << line
    self.column_count = line.count
    self.rows << line.map{ |item| Item.new(item) }
  end

  def number_selected number
    rows.each do |line|
      line.each do |item|
        item.selected!(number)
      end
    end
  end

  def completed?
    return true if completed

    row_completed = rows.any? do |line|
      line.all?(&:checked?)
    end

    column_completed = rows.transpose.any? do |line|
      line.all?(&:checked?)
    end

    return unless row_completed || column_completed

    completed!
    true
  end

  def completed!
    @completed = true
  end

  def incomplete?
    !@completed
  end

  def total_value bingo_number
    unchecked = rows.flat_map do |line|
      line.select(&:unchecked?).map(&:value)
    end.compact.sum

    unchecked * bingo_number
  end

  def print
    rows.each do |line|
      puts line.map(&:to_s).join(' ')
    end
    puts ""
  end
end

def read_and_load_matrices file_path
  input = File.readlines file_path

  bingo_numbers = input.first.strip.split(',').map(&:to_i)

  matrices = []
  matrix = Matrix.new
  input[2..].each do |line|
    if line == "\n"
      matrices << matrix
      matrix = Matrix.new
    else
      matrix << line.split(' ')
    end
  end

  [bingo_numbers, matrices]
end

def part_1
  bingo_numbers, matrices = read_and_load_matrices('input_part1')

  bingo_numbers.each do |number|
    puts "----------------- #{number} --------------------"
    matrices.each{ |matrix| matrix.number_selected(number) }
    matrices.each(&:print)
    puts '------------------------------------------------'

    if completed = matrices.detect(&:completed?)
      puts "Completed"
      completed.print
      puts completed.total_value(number)
      break
    end
  end
end

def part_2
  bingo_numbers, matrices = read_and_load_matrices('input_part1')

  bingo_numbers.each do |number|
    if matrices.count(&:completed?) == matrices.count - 1
      matrix = matrices.detect(&:incomplete?)
      matrix.number_selected(number)

      if matrix.completed?
        puts matrix.total_value(number)
      end
    else
      matrices.each{ |matrix| matrix.number_selected(number) }
    end
  end
end

# part_1
part_2
