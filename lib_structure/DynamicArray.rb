class DynamicArray
  attr_accessor :index, :value
  def initialize
    index, value, last_index = @index, @value, @last_index
  end


#  function insertEnd(dynarray a, element e)
#      if (a.size = a.capacity)
#          // resize a to twice its current capacity:
#          a.capacity ← a.capacity * 2
#          // (copy the contents to the new memory location here)
#      a[a.size] ← e
#      a.size ← a.size + 1

  def push(value = nil, index = 0)

    self.index = 0
    self.value = value
    for i in 1 .. 5
      self.push(5, i)
    end
  end
end


test = DynamicArray.new

test.push(1)

puts test.inspect
