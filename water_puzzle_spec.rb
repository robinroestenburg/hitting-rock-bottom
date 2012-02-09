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

    it 'creates a row for each line of input' do
      subject.grid.size == 4
    end

    it 'creates grid containing the rows of the cave' do
      subject.grid[0].should == ['#', '#', '#', '#']
      subject.grid[1].should == ['~', '~', ' ', '#']
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
      subject.grid = [['#'],[' '],[' '],[' '],['~'],[' '],['#']]
      subject.flowing?(subject.grid.transpose[0]).should be_true
    end

    it 'detects a non-flowing column' do
      subject.grid = [['#'],[' '],[' '],[' '],['~'],['~'],['#']]
      subject.flowing?(subject.grid.transpose[0]).should be_false
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
