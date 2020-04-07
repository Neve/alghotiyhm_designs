'''
Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:

Given nums = [2,5,5,11], target = 10,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].

'''
class Solution(object):
    def twoSum(self, nums, target):
        # defining a set for index store
       num_set = {}
       # iterating through indexes generated by enumerate for given set of numbers
       for num_index, num in enumerate(nums):
           # if 10-2 in {}
           if (target-num) in num_set:
               
               return [num_set[target-num], num_index]
           num_set[num] = num_index
       print num_set

        
nums =[2,5,5,11]
target = 10
sol = Solution()
result = sol.twoSum(nums,target)
print result

'''
Accepted
Runtime: 36 ms
Your input
[2,5,5,15]
10
Output
[1,2]
Expected
[1,2]
'''
