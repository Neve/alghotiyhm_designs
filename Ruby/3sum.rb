# Algorithm to find 3 integers adding up to 0
# https://www.glassdoor.com/Interview/Algorithm-to-find-3-integers-adding-up-to-0-QTN_1826494.htm
# http://stackoverflow.com/questions/1283231/given-an-array-of-numbers-find-out-if-3-of-them-add-up-to-0
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==-25)
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==-22)
#  . . .
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==-7)
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==-7)
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==-3)
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==2)
#  -25 -10 -7 -3 2 4 8 10  (a+b+c==0)

# #def triplet_sum(alist, total):
#     alist.sort() #modifies the list in place - more efficient than sorted() but not great if we need the list unmodified
#     left, right = 0, len(alist) - 1
#     while right > left:
#         elem = total - alist[left] - alist[right]
#         mid = binary_search(alist, elem, left, right)
#         if mid >= 0: #found
#             return (alist[left], alist[mid], alist[right])
#         elif mid == -10: #terminated left
#             right -= 1
#         elif mid == -20: #terminated right
#             left += 1
#     return None
#
#     First sort the list - O(nlgn) time
#     left starts as 0, and right as n-1 (last index)
#     Binary search for the third element that completes the total sum - O(logn) time
#     If found, return the triplet
#     If the binary search terminates in the left side of the list, decrement right
#     If the binary search terminates in the right side, increment left
#
# The while loop runs O(n) times, each time doing O(logn) work, for a total of O(nlogn). Let me know if this helps, and I'd love to hear any improvements/suggestions.



# for each i from 1 to len(array) - 1
#   iter = i + 1
#   reviter = len(array) - 1
#   while iter < reviter
#     tmp = array[iter] + array[reviter] + array[i]
#     if  tmp > 0
#        reviter--
#     else if tmp < 0
#        iter++
#     else
#       return true
# return false

array = [-25, -10, -7, -3, 2, 4, 8, 10].sort

def zero_sum_finder(array)
  array_len = array.length
  for i in 0 ...array_len - 1  do
    iter = i
    reviter = array_len - 1
    while iter < reviter do
      tmp = array[iter] + array[reviter] + array[i]
      if tmp > 0
        reviter-=1
      elsif tmp < 0
        iter+=1
      else
        puts "tmp #{tmp} success #{array[iter]} + #{array[reviter]} + #{array[i]}"
        break
      end

    end
    puts "false"

  end
    return false


end


zero_sum_finder(array)


