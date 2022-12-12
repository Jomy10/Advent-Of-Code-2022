require 'ruby2D'

SCALE = 10

input = File.read("example.txt")

set width: (input.lines[0].length-1) * 10, height: input.lines.length * 10

t1 = Thread.new { draw(false, input) }
t2 = Thread.new { draw(true, input) }
def draw(type, input)
  x = 0
  y = 0
  prevIsWhite = false
  for line in input.lines
    Thread.new(x, y, prevIsWhite, line) { |x, y, prevIsWhite, line|
      for char in line.chars
        if type
          Square.new(
            x: x * SCALE, y: y * SCALE,
            size: SCALE,
            color: prevIsWhite ? 'black' : 'white',
            z: 0
          )
        else
          Text.new(
            char.to_s,
            x: x * SCALE + SCALE / 4, y: y * SCALE - SCALE / 4,
            color: prevIsWhite ? 'white' : 'black',
            size: SCALE,
            z: 10
          )
        end
        x += 1
        prevIsWhite = !prevIsWhite
      end
    }
    x = 0
    y += 1
    prevIsWhite = !prevIsWhite
  end
end

Thread.new {
  current = nil
  nexts = []
  for line in File.read("visualize.txt").lines
    if /next \((\d+), (\d+)\)/ =~ line
      nexts << Square.new(
        x: $1.to_i * SCALE, y: $2.to_i * SCALE,
        size: SCALE,
        color: 'blue',
        z: 3
      )
    elsif /currrent \((\d+), (\d+)\)/ =~ line
      # gets
      sleep 0.1
      if !current.nil?
        current.remove
      end
      current = Square.new(
        x: $1.to_i * SCALE, y: $2.to_i * SCALE,
        size: SCALE,
        color: 'red',
        z: 2
      )
      nexts.each do |sq|
        sq.remove
      end
    end
  end
}

show
