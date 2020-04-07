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


end


duplicate_remover(given_string)
