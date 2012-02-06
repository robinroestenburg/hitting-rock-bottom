require 'matrix'

class Cave

  attr_accessor :columns

  def self.build(lines)
    cave = Cave.new
    cave.columns = Matrix.rows(lines.tap { |lines| lines.collect! { |line| line.strip.split('') }})
    cave
  end

  def add_water

    # find last water element in Cave
    column, row = last_water_element

    if /^#[[:space:]]*[~]+[[:space:]]+#/ =~ columns.column(column).to_a.join
      columns.column(column).add_water

    elsif columns[column + 1, row] == ' '
      columns[column + 1, row] = '~'

    elsif columns[column + 1, row] == '#'
      last_element_column =  (0..column).select { |i| columns[i].value[row - 1] == '~' }.last
      columns[last_element_column + 1].add_water
    end
  end

  def last_water_element

    elements = []
    columns.each_with_index do |element, row, column|
      if element == '~'
        elements << [column, row]
      end
    end
    elements.last

    # columns.column_vectors.each do |column|
    #   column.reverse_each do |element|
    #     if element == '~'
    #       if column.flowing? || columns[column_no - 1].value[row] != '~'
    #       return [column_no, row]
    #     else
    #       return [column_no, column.value.index('~')]
    #     end
    #   end

    #   column_no -= 1
    # end
  end

  def to_s
    columns.row_vectors.collect do |row|
      row.to_a.join << "\n"
    end.join
  end

  def to_depth_string
    columns.column_vectors.collect do |column|
      if /^#[[:space:]]*[~]+[[:space:]]+#/ =~ column.to_a.join
        '~ '
      else
        "#{column.count('~')} "
      end
    end.join.strip
  end

end

class Column

  attr_accessor :value

  def initialize(value = '')
    @value = value
  end

  def depth
    return '~' if flowing?
    value.count('~')
  end

  def flowing?
    /^#[[:space:]]*[~]+[[:space:]]+#/ =~ value
  end

  def add_water
    if flowing?
      water_position = value.rindex('~')
      value[water_position + 1] = '~'
    else
      water_position = value.index('~') || value.index('#') - 1
      value[water_position - 1] = '~' unless water_position - 1 == 0
    end
  end

end


# Testing 1 2 3...
f = File.new('complex_cave.txt')
lines = f.readlines

    p lines.tap { |lines| lines.collect! { |line| line.strip.split('') }}
      # m = Matrix.rows([lines[2..lines.size-1]])
      # puts m.row(0)

# cave = Cave.build(lines[2..lines.size-1])
#
# 999.times do
#   cave.add_water
#   # puts cave.to_s
# end
# puts cave.to_s
# puts cave.to_depth_string
# puts '1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0'
#
#
