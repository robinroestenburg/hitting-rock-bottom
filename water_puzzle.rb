require 'matrix'

class Matrix
  public :"[]=", :set_element, :set_component
end

class Cave

  attr_accessor :grid

  def self.build(lines)
    cave = Cave.new
    cave.grid = Matrix.rows(lines.tap { |lines| lines.collect! { |line| line.strip.split('') }})
    cave
  end

  def add_water

    elements = []
    grid.each_with_index do |element, row, col|

      if element == '~' && grid[row + 1, col] == ' '
        grid[row + 1, col] = '~'
        return
      end

      if element == ' ' &&  grid[row, col - 1] == '~'
        elements << [row, col]
      end

    end

    row, col = elements.last
    grid[row, col] = '~'
  end

  def flowing?(column)
    /^#[[:space:]]*[~]+[[:space:]]+#/ =~ column.to_a.join
  end

  def to_s
    grid.row_vectors.collect do |row|
      row.to_a.join
    end.join("\n")
  end

  def to_depth_string
    grid.column_vectors.collect do |column|
      if flowing?(column)
        '~'
      else
        "#{column.count('~')}"
      end
    end.join(' ')
  end
end

f = File.new('complex_cave.txt')
lines = f.readlines

cave = Cave.build(lines[2..lines.size-1])

1999.times do
  cave.add_water
end

puts cave.to_s
