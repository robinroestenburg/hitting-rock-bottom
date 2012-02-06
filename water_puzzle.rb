require 'matrix'

class Matrix
  public :"[]=", :set_element, :set_component
end

class Cave

  attr_accessor :columns

  def self.build(lines)
    cave = Cave.new
    cave.columns = Matrix.rows(lines.tap { |lines| lines.collect! { |line| line.strip.split('') }})
    cave
  end

  def add_water
    column, row = last_water_element
    add_water_to_column_and_row(column, row)
  end

  def add_water_to_column_and_row(column, row)

    if flowing?(column)
      add_water_to_column(column)

    elsif columns[row, column + 1] == ' '
      columns[row, column + 1] = '~'

    elsif columns[row, column + 1] == '#'
      last_element_column = columns.row(row - 1).to_a.join.rindex('~')
      add_water_to_column_and_row(last_element_column, row - 1)
    end
  end

  def add_water_to_column(column)
    if flowing?(column)
      row = columns.column(column).to_a.rindex('~')
      columns[row + 1, column] = '~'
    else
      row = columns.column(column).to_a.index('~') || columns.column(column).to_a.index('#') - 1
      columns[row - 1, column] = '~' unless row - 1 == 0
    end
  end

  def flowing?(column)
    /^#[[:space:]]*[~]+[[:space:]]+#/ =~ columns.column(column).to_a.join
  end

  def last_water_element

    elements = []
    columns.each_with_index do |element, row, column|
      if element == '~'
        elements << [column, row]
      end
    end
    elements.last
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


