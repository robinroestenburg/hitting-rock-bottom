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

  describe '#flowing?(column)' do
    it 'detects a flowing column' do
      subject.grid = Matrix[['#'],[' '],[' '],[' '],['~'],[' '],['#']]
      subject.flowing?(subject.grid.column(0)).should be_true
    end

    it 'detects a non-flowing column' do
      subject.grid = Matrix[['#'],[' '],[' '],[' '],['~'],['~'],['#']]
      subject.flowing?(subject.grid.column(0)).should be_false
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
      subject.to_s.should == "####\n~~ #\n#~~#\n####"
    end

  end
end
