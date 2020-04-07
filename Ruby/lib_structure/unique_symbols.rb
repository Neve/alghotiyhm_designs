str = "Implement an algorithm to determine if a string has all unique characters  What if you can not use additional data structures"
#Implement an algorithm to determine if a string has all unique characters  What if you can not use additional data structures
#000000000010000000000000000000001000000000000000000000000000000000000000010000000000000100000000010111111100111111111100010000
# ASCII version
# first create string with zeros equal to length of given string
# check converting each char of given string to ascii number as string index number with given string if it missing - put 1 instead of zero in checker_str
# "00000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000" '1' have index 109 which is the ascii code of "I"
def str_checker(input_str)
  checker_str = '0' * input_str.length

  for i in 0 ... input_str.length
    input_str_char_byte = input_str.getbyte(i)
    puts input_str_char_byte

    if checker_str[input_str_char_byte] == "1"
      puts "#{checker_str}||#{input_str_char_byte} || #{i}"
    else
      checker_str[input_str_char_byte] = "1"
    end

  end
end

str_checker(str)