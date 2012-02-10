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

    # Je wilt elementen die eigen position kennen in grid, waar je
    # - underneath_water
    # - next_to_water
    # - has_water?
    # - fill
    # aan kan vragen.

    grid.reverse.each_with_index do |row, row_index|
      row.reverse.each_with_index do |value, column_index|

        i = (grid.size - 1) - row_index
        j = (row.size - 1) - column_index

        if value == ' '
          if underneath_water?(i, j) || next_to_water?(i, j)
            grid[i][j] = '~'
            return
          end
        end
      end

    end
  end

  def flowing?(column)
    column.to_a.join.index('~ ')
  end

  def to_s
    grid.collect { |row| row.to_a.join }.join("\n")
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

  private

  def next_to_water?(i, j)
    grid[i][j - 1] == '~'
  end

  def underneath_water?(i, j)
    grid[i - 1][j] == '~'
  end

end

# f = File.new('complex_cave.txt')
# lines = f.readlines
#
# cave = Cave.build(lines[2..lines.size-1])
#
# 1999.times do
#   cave.add_water
# end
#
# puts cave.to_s
