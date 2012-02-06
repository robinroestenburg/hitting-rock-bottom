require_relative 'water_puzzle'

describe Cave do

  it 'has columns' do
    columns = stub
    subject.columns = columns

    subject.columns.should == columns
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
      subject.columns.column_size == 4
    end

    it 'creates columns containing the column of the cave' do
      subject.columns.column(0).should == Vector['#', '~', '#', '#']
      subject.columns.column(1).should == Vector['#', '~', '~', '#']
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

describe Column do

  context 'without water' do
    subject { Column.new('#     #') }

    its(:depth) { should == 0 }
  end

  context 'with water' do
    subject { Column.new('#   ~~#') }

    its(:depth) { should == 2 }
  end

  context 'with flowing water' do
    subject { Column.new('#  ~  #') }

    its(:depth) { should == '~' }
  end

  describe '#add_water' do

    it 'adds one element of water to an empty column' do
      subject.value = '#     #'
      subject.add_water
      subject.value.should == '#    ~#'
    end

    it 'adds one element of water to a column' do
      subject.value = '#   ~~#'
      subject.add_water
      subject.value.should == '#  ~~~#'
    end

    it 'adds one element of water to a flowing column' do
      subject.value = '#  ~  #'
      subject.add_water
      subject.value.should == '#  ~~ #'
    end

    it 'adds no water to an already full column' do
      subject.value = '#~~~~~#'
      subject.add_water
      subject.value.should == '#~~~~~#'
    end
  end
end
