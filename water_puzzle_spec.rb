require_relative 'water_puzzle'

describe Cave do

  it 'has grid' do
    grid = stub
    subject.grid = grid

    subject.grid.should == grid
  end

  describe '#build' do

    let(:cave_input) do
      lines = []
      lines << "####\n"
      lines << "~~ #\n"
      lines << "#~~#\n"
      lines << "####\n"
    end

    subject { Cave.build(cave_input) }

    it 'creates a Column for each column' do
      subject.grid.column_size == 4
    end

    it 'creates grid containing the column of the cave' do
      subject.grid.column(0).should == Vector['#', '~', '#', '#']
      subject.grid.column(1).should == Vector['#', '~', '~', '#']
    end
  end

  describe '#add_water' do

    let(:cave_input) do
      lines = []
      lines << "#######\n"
      lines << "~     #\n"
      lines << "#   # #\n"
      lines << "#######\n"
    end

    subject { Cave.build(cave_input) }

    it 'adds one element of water to the cave' do
      subject.add_water
      subject.to_depth_string.should == '1 ~ 0 0 0 0 0'
    end

    it 'adds two elements of water to the cave' do
      2.times { subject.add_water }
      subject.to_depth_string.should == '1 2 0 0 0 0 0'
    end

    it 'adds three elements of water to the cave' do
      3.times { subject.add_water }
      subject.to_depth_string.should == '1 2 1 0 0 0 0'
    end

    it 'adds 5 elements of water to the cave' do
      5.times { subject.add_water }
      subject.to_depth_string.should == '1 2 2 1 0 0 0'
    end
  end


  describe '#add_water_to_column_and_row(column, row)' do

    it 'adds one element of water to an empty column' do
      subject.grid = Matrix[['#', '#'],
                               ['~', ' '],
                               ['#', ' '],
                               ['#', ' '],
                               ['#', ' '],
                               ['#', '#']]
      subject.add_water_to_column_and_row(0, 1)
      subject.to_s.should == "##\n~~\n# \n# \n# \n##\n"
    end

    it 'adds one element of water to an blocked column' do
      subject.grid = Matrix[['#', '#', '#', '#'],
                               ['~', '~', ' ', ' '],
                               ['#', '~', ' ', ' '],
                               ['#', '~', ' ', ' '],
                               ['#', '~', '~', '#'],
                               ['#', '#', '#', '#']]
      subject.add_water_to_column_and_row(2, 4)
      subject.to_s.should == "####\n~~  \n#~  \n#~~ \n#~~#\n####\n"
    end
  end

  describe '#add_water_to_column(column)' do

    it 'adds one element of water to an empty column' do
      subject.grid = Matrix[['#'],[' '],[' '],[' '],[' '],[' '],['#']]
      subject.add_water_to_column(0)
      subject.grid.to_a.join.should == '#    ~#'
    end

    it 'adds one element of water to a column' do
      subject.grid = Matrix[['#'],[' '],[' '],[' '],['~'],['~'],['#']]
      subject.add_water_to_column(0)
      subject.grid.to_a.join.should == '#  ~~~#'
    end

    it 'adds one element of water to a flowing column' do
      subject.grid = Matrix[['#'],[' '],[' '],['~'],[' '],[' '],['#']]
      subject.add_water_to_column(0)
      subject.grid.to_a.join.should == '#  ~~ #'
    end

    it 'adds no water to an already full column' do
      subject.grid = Matrix[['#'],['~'],['~'],['~'],['~'],['~'],['#']]
      subject.add_water_to_column(0)
      subject.grid.to_a.join.should == '#~~~~~#'
    end
  end

  describe '#flowing?(column)' do
    it 'detects a flowing column' do
      subject.grid = Matrix[['#'],[' '],[' '],[' '],['~'],[' '],['#']]
      subject.flowing?(0).should be_true
    end

    it 'detects a non-flowing column' do
      subject.grid = Matrix[['#'],[' '],[' '],[' '],['~'],['~'],['#']]
      subject.flowing?(0).should be_false
    end
  end

  describe '#last_water_element' do

    it 'detects which column and row holds the last water element' do
      lines = []
      lines << "####\n"
      lines << "~  #\n"
      lines << "#  #\n"
      lines << "####\n"

      Cave.build(lines).last_water_element.should == [0, 1]
    end

    it 'detects which column and row holds the last water element when flowing' do
      lines = []
      lines << "####\n"
      lines << "~~ #\n"
      lines << "#  #\n"
      lines << "####\n"

      Cave.build(lines).last_water_element.should == [1, 1]
    end

    it 'detects which column and row holds the last water element when full column' do
      lines = []
      lines << "####\n"
      lines << "~~ #\n"
      lines << "#~ #\n"
      lines << "####\n"

      Cave.build(lines).last_water_element.should == [1, 2]
    end

    it 'detects which column and row holds the last water element' do
      lines = []
      lines << "####\n"
      lines << "~~ #\n"
      lines << "#~~#\n"
      lines << "####\n"

      Cave.build(lines).last_water_element.should == [2, 2]
    end

    it 'detects which column and row holds the last water element' do
      lines = []
      lines << "####\n"
      lines << "~~~#\n"
      lines << "#~~#\n"
      lines << "####\n"

      Cave.build(lines).last_water_element.should == [2, 2]
    end
  end

  describe '#to_depth_string' do

    context 'no flowing water' do
      let(:cave_input) do
        lines = []
        lines << "####\n"
        lines << "~~ #\n"
        lines << "#~~#\n"
        lines << "####\n"
      end

      subject { Cave.build(cave_input) }

      it 'prints the depth of each column in a row' do
        subject.to_depth_string.should == '1 2 1 0'
      end
    end

    context 'flowing water' do

      let(:cave_input) do
        lines = []
        lines << "####\n"
        lines << "~~ #\n"
        lines << "#  #\n"
        lines << "####\n"
      end

      subject { Cave.build(cave_input) }

      it 'prints the depth of each column in a row' do
        subject.to_depth_string.should == '1 ~ 0 0'
      end
    end
  end

  describe '#to_s' do

    let(:cave_input) do
      lines = []
      lines << "####\n"
      lines << "~~ #\n"
      lines << "#~~#\n"
      lines << "####\n"
    end

    subject { Cave.build(cave_input) }

    it 'prints the cave' do
      subject.to_s.should == "####\n~~ #\n#~~#\n####\n"
    end

  end
end
