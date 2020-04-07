# Battleship game: write a function that finds a ship and return its coordinates.
# matrix - given battelfield
# x,y Interger matrix coordinates from here to search
# direction Boolean true - horizontal (by x)| false - vertical by y
def check_neighbour_coordinate(matrix, x, y, direction = true|false)
  search_direction = y
  passive_direction = x
  if direction
    search_direction = x
    passive_direction = y
  end

  results = []
   # There should be no negative coordinates
  if search_direction == 0
    search_direction_minus = search_direction
  else
    search_direction_minus = search_direction - 1
  end
  [search_direction_minus, search_direction + 1].each do |neighbour_coordinate|
    if matrix[neighbour_coordinate][passive_direction]
      results.push([neighbour_coordinate, passive_direction])
    end
  end

end

battlefield = [
  [false, false, false, false, false, false, false, false, false, false],
  [false, true, false, false, false, false, false, false, false, false],
  [false, true, false, false, false, false, false, false, false, false],
  [false, true, false, false, false, false, false, false, false, false],
  [false, true, false, false, false, false, false, false, false, false],
  [false, true, false, false, false, false, false, false, false, false],
  [false, false, false, false, false, false, false, false, false, false],
  [false, false, false, false, false, false, false, false, false, false],
  [false, false, false, false, false, false, false, false, false, false],
  [false, false, false, false, false, false, false, false, false, false]
]
battlefield.inspect

puts "enter coordinates x and y. 0 is at top right "
player_x = 3
player_y = 1


if battlefield[player_x][player_y]
  puts "we hit something"

# here we will store info about the opponent ships
  ships = {
    0.to_s => [[1, 1], [2, 1], [3, 1], [4, 1]]
  }
  ships = {}
# saving first coordinate
  the_ship = [[player_x, player_y]]

# lets check the search destination, the ship could be either vertical or horizontal
  search_vertical = false
  found_positions = check_neighbour_coordinate(battlefield, player_x, player_y, true)
  if found_positions.empty
    # wich means that the ship located vertically
    search_vertical = true
  else
    the_ship.push(found_positions)
  end


  the_ship.sort!
# [[1, 1], [2, 1]]

  while true do
    if search_vertical
      # Get the top and bottom ship coordinates
      known_top = the_ship.first
      known_bottom = the_ship.last

      check_neighbour_coordinate(battlefield, x, y, direction = true|false)
    end
  end

  puts "coordinates found #{the_ship.inspect}. Searching vertical #{search_vertical}"


else
  puts "we miss. try again battlefield[player_x, player_y] #{battlefield[player_x, player_y]}"
end