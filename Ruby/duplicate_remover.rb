given_string = "abcdeafab"

def duplicate_remover (input_string)

  for i in 0 .. input_string.length
    for j in 1 .. input_string.length
      if (input_string[i] == input_string[j]) && (j != i)
        puts "duplicates #{input_string[i]} == #{input_string[j]}"
        input_string[j] = " "
      end
    end
    puts input_string
  end

=begin
  tail_count = 1
  for i in 1 .. input_string.length-1
    for j in 0 .. tail_count
	  if input_string[i] == input_string[j]
	    puts "#{input_string[i]} == #{input_string[j]}"
		break
	  end
	  
	  if j == tail_count 
	   input_string[tail_count] = input_string[i]
	   tail_count += 1
	  end

	end

  end
  input_string[tail_count] = "0"
  puts input_string
=end
end

duplicate_remover(given_string)
