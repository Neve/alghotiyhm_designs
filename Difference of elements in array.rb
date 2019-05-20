# Example 3. Given is a sorted array A. Determine whether it contains two elements with the difference D. 
#int j=0;
#for (int i=0; i<N; i++) {
#  while ( (j<N-1) && (A[i]-A[j] > D) )
#    j++;
#  if (A[i]-A[j] == D) return 1;
#}

A = [1, 4, 5, 6, 8]
D = 2
N = A.length

j=0
for i in 0 ... N do

  while ((j<N-1) && (A[i]-A[j] > D)) do
    j += 1
    puts("j is #{j}")
  end

  if A[i]-A[j] == D
    puts "Match #{A[i]} - #{A[j]}"
  end
end


#for i in 0 .. A.length
#  puts "#{A[i]}"
#  if A[i] - A[i-1] == D 
#    puts "#{A[i]} - #{A[i-1]}"
#  end
#end


