class Stack 



def initialize
@stack_size = 300
@buffer = []*@stack_size * 3
@stack_pointer = [0,0,0]
end
def push(stack_num, value)
  puts " -- #{@stack_size}"
  puts @stack_pointer.inspect
  index = stack_num * @stack_size + @stack_pointer[stack_num] + 1
  puts "index is #{index}"
  @stack_pointer[stack_num] += 1
  @buffer[index] = value
  puts @buffer.inspect
  
end

def pop (stack_num)
  index = stack_num * stack_size + stack_pointer[stack_num]
  stack_pointer[stack_num] -= 1
  value = buffer[index]
  buffer[index] = 0
  return value
end
end

ms = Stack.new

ms.push(1,5)
=begin
ms.push(2,5)
for i in 2 .. 7 
  ms.push(0,i)
end

for i in 2 .. 7 
  ms.push(1,i)
end

for i in 2 .. 7 
  ms.push(2,i)
end
=end