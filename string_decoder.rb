# Write code to decode strings. 
# For example, String str = "3[a2[bd]g4[ef]h]", 
# the output should be "abdbdgefefefefhabdbdgefefefefhabdbdgefefefefh". 

# O(n^2)

# Using stacks we
str = '3[a2[bd]g4[ef]h]'


num_stack = []
str_stack = []
current_string = ""
current_num = 0

str.each_char do |char|

  case
    # adding number of iterations to temp variable
    # we will save this into stack when we will found the '[' symbol
  when char[/\d/] # (ch >= '0' && ch <= '9')
    current_num = char[/\d/]

    # adding chars to current string it usually is a group of chars between [] like 'ef'
    # or
  when (char >= 'a' && char <= 'z')
    current_string << char
    # when we hit [ sign, which means the beginning of embedded sequence
    # we saving current values into top of the stack
    # saving number of iterations of embedded sequence into the stack
    # to reuse them in next when condition
    #
    # saving the 'big string' in top of the stack
    # to re-use the 'current_string' variable for embedded sequence
  when (char == '[')
    num_stack.push(current_num)
    current_num = 0
    str_stack << current_string
    current_string = ''
    # We taking top values from stack which actually is the save string from previous iterations
    # and number of iterations for "current_string" which holds the embedded sequence
    # after that iterating required number of times adding embedded string to 'big string
    # and the last step is save of result string to 'current_string' for further iterations
  when (char == ']')
    str_stack_top = str_stack.last
    str_stack.pop
    num_stack_top = num_stack.last
    num_stack.pop

    num_stack_top.to_i.times do
      str_stack_top += current_string
    end

    current_string = str_stack_top

  else
    puts 'unsupported symbol'
  end

end

puts "current string #{current_string}"
