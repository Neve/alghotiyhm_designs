given_matrix = [[0, 1, 2, 3], [2, 4, 5, 6], [7, 8, 0, 9]]

def zero_filler(input_matrix)
  puts input_matrix.inspect
  #internal_matrix = [[1]*input_matrix[0].length]*input_matrix.length
  #puts internal_matrix.inspect

  row = ["x"]*input_matrix[0].length
  column = ["x"]*input_matrix.length

  for i in 0 ... input_matrix.length
    for j in 0 ... input_matrix[0].length
      if input_matrix[i][j] == 0
        row[i] = 1
        column[j] = 1
      end
    end
  end
  puts row.inspect
  puts column.inspect
  for i in 0 ... input_matrix.length
    for j in 0 ... input_matrix[0].length
      if (row[i] == 1 || column[j] == 1)
        input_matrix[i][j] = 0
      end
    end
  end

  puts input_matrix.inspect
end

zero_filler(given_matrix)