## Hitting Rock Bottom

Ruby implementation of the Hitting Rock Bottom puzzle from the PuzzleNode's
site as part of this weeks Rubies in the Rough assignment.

I also wanted to get a bit more experience in using the Matrix datatype, so
that's why I modelled the Cave using a Matrix.

### Usage
Example usage:

~~~ ruby
lines = File.new('simple_cave.txt').readlines

cave = Cave.build(lines[2..lines.size-1])

99.times do
  cave.add_water
end
puts cave.to_s
~~~
