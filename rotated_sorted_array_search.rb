# https://www.glassdoor.com/Interview/Given-a-list-of-integers-which-are-sorted-but-rotated-4-5-6-1-2-3-search-for-a-given-integer-in-the-list-QTN_580996.htm
#     Given a list of integers which are sorted, but rotated   ([4, 5, 6, 1, 2, 3]), search for a given integer in the list. 

#Search(set):
#    if size of set is 1 and set[0] == item 
#        return info on set[0]
#    divide the set into parts A and B
#    if A is sorted and the item is in the A's range
#        return Search(A)
#    if B is sorted and the item is in the B's range
#        return Search(B)
#    if A is not sorted
#        return Search(A)
#    if B is not sorted
#        return Search(B)
#    return "not found"


target_array = [4, 5, 6, 1, 2, 3]
element_to_find = 6


def search(array, element_to_find, left_bond, right_bond)
  middle = (left_bond+right_bond)/2

  if array[middle] == element_to_find
    return array[middle]
  end

  puts "array[middle] #{array[middle]}"
  puts "array[left_bond] #{array[left_bond]}"

  case
  #sorted mean that a - a-1 == 1
  when array[middle]-array[middle-1] == 1 && element_to_find.between?(array[left_bond], array[middle])
    search(array, element_to_find, left_bond, middle-1)
  when array[middle] - array[middle+1] == 1 && element_to_find.between?(array[middle], array[right_bond])
    search(array, element_to_find, middle+1, right_bond)
  when array[middle] < array[left_bond]
    search(array, element_to_find, left_bond, middle-1)
  when array[middle] > array[left_bond]
    search(array, element_to_find, middle+1, right_bond)
  end

end

result = search(target_array, element_to_find, 0, target_array.length)
puts result