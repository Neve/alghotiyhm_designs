# Write code to reverse a C-Style String  (C-String means that �abcd� is represented as 
# five characters, including the null character )

c_string = "abcd"

def string_reverse(input_string)
  stack = ' ' * input_string.length

  for i in 0 .. input_string.length
    chr = input_string[i]
    puts chr
    if chr ==nil
      stack[input_string.length - i] = ''
    else
      stack[input_string.length - i] = chr
    end

    puts "<#{stack}>"
  end


  len = input_string.chop.length
  puts len
  stack = ' ' * len
  for i in 0 .. len
    stack[len - i] = input_string[i]
    puts "<#{stack}>"
  end
  puts "<#{stack}>"
end

string_reverse(c_string)
