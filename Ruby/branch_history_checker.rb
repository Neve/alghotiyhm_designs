# For a given set of software checkins, write a program that will determine which part along the branch where the fault lies. 

# https://www.glassdoor.com/Interview/For-a-given-set-of-software-checkins-write-a-program-that-will-determine-which-part-along-the-branch-where-the-fault-lies-QTN_384079.htm
# https://gist.github.com/aspyct/3433278
#check(A[0]) = true - first version is fine
#check(A[n-1]) = false - last version has the fault

# binary search:

def binary_search(target_array, element_to_find, min_boarder = 0, max_boarder = nil)
  if max_boarder.nil?
    max_boarder = target_array.length-1
  end

  middle = (min_boarder+max_boarder)/2

# whether the arguments are equal or unequal, the spaceship operator will return 1, 0, or −1 depending on the value of the left argument relative to the right argument.
#  a <=> b :=
#  if a < b then return -1
#  if a = b then return  0
#  if a > b then return  1
#  if a and b are not comparable then return nil

  compare = element_to_find <=> target_array[middle]
  
  if compare.nil?
    raise ArgumentError.new("#{element_to_find} not comparable with #{target_array}")
  end

# not found
  return -1 if min_boarder == max_boarder && compare != 0

  case compare
    when 0
      # Which  means that we have found our element
      middle
    when -1
      # looking in left part of array
      binary_search(target_array, element_to_find, min_boarder, middle - 1)
    when 1
      # looking it the right part
      binary_search(target_array, element_to_find, middle + 1, max_boarder)
  end


end

version_array = [100,200,300,400,500,600,700,800]

# a[5]-a[6] fault
# a[0]-a[4] healthy

fialed_el = binary_search(version_array, 600)
# puts fialed_el

# element_index = 6
failed_builds = version_array[fialed_el, version_array.length]
puts failed_builds.inspect
