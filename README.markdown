## Hitting Rock Bottom

Ruby implementation of the Hitting Rock Bottom puzzle from the PuzzleNode's
site. I focused on using the Matrix datatype for this one.

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
