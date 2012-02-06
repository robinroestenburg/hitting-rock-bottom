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
    column, row = last_water_element
    add_water_to_column_and_row(column, row)
  end

  def add_water_to_column_and_row(column, row)

    if grid[row + 1, column] == ' '
      add_water_to_column(column)

    elsif grid[row, column + 1] == ' '
      grid[row, column + 1] = '~'

    elsif grid[row, column + 1] == '#'
      last_element_column = grid.row(row - 1).to_a.join.rindex('~')
      add_water_to_column_and_row(last_element_column, row - 1)
    end

  end

  def add_water_to_column(column)
    if flowing?(column)
      row = grid.column(column).to_a.rindex('~')
      grid[row + 1, column] = '~'
    else
      row = grid.column(column).to_a.index('~') || grid.column(column).to_a.index('#') - 1
      grid[row - 1, column] = '~' unless row - 1 == 0
    end
  end

  def flowing?(column)
    /^#[[:space:]]*[~]+[[:space:]]+#/ =~ grid.column(column).to_a.join
  end

  def last_water_element

    elements = []
    grid.each_with_index do |element, row, column|
      if element == '~'
        elements << [column, row]
      end
    end
    elements.last
  end

  def to_s
    grid.row_vectors.collect do |row|
      row.to_a.join << "\n"
    end.join
  end

  def to_depth_string
    grid.column_vectors.collect do |column|
      if /^#[[:space:]]*[~]+[[:space:]]+#/ =~ column.to_a.join
        '~ '
      else
        "#{column.count('~')} "
      end
    end.join.strip
  end
end


