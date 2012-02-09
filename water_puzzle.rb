class Cave

  attr_accessor :grid

  def self.build(lines)
    cave = Cave.new

    cave.grid = lines.tap do |lines|
      lines.collect! { |line| line.strip.split('') }
    end

    cave
  end

  def add_water

    elements = []

    grid.each_with_index do |row, row_index|
      row.each_with_index do |element, column_index|


      if element == '~' && grid[row_index + 1][column_index] == ' '
        grid[row_index + 1][column_index] = '~'
        return
      end

      if element == ' ' &&  grid[row_index][column_index - 1] == '~'
        elements << [row_index, column_index]
      end

      end
    end

    row, col = elements.last
    grid[row][col] = '~'
  end

  def flowing?(column)
    /^#[[:space:]]*[~]+[[:space:]]+#/ =~ column.to_a.join
  end

  def to_s
    grid.collect do |row|
      row.to_a.join
    end.join("\n")
  end

  def to_depth_string
    grid.transpose.collect do |column|
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
