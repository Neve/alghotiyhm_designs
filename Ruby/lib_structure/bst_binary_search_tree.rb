class Btree
  attr_accessor :value, :left, :right, :parent

  def initialize(value = nil, left = nil, right = nil, parent = nil)
    @value, @left, @right, @parent = value, left, right

  end
end

def insert(node, value, &block)
  a_left = []
  a_right = []
  i= 0

  return Btree.new(value) if not node

  case block[value]
  when -1
    node.left = insert(node.left, value, &block)
    a_left[i] = value
  when 1
    node.right = insert(node.right, value, &block)
    a_right[i] = value
  when 0
    puts "!!value"
  end
  i +=1
  # puts "a_left #{a_left.inspect}"
  #puts "a_right #{a_right.inspect}"

  return node
end

def visit (n, order = :preorder, &block)
  if n == nil
    return false
  end

  case order
  when :left
    yield n.value
    visit(n.left, order, &block)
  when :right
    yield n.value
    visit(n.right, order, &block)
  when :preorder
    yield n.value
    visit(n.left, order, &block)
    visit(n.right, order, &block)
  when :inorder
    visit(n.left, order, &block)
    yield n
    visit(n.right, order, &block)
  when :ansest
    yield n.value
    visit(n.right, order, &block)

  end

end

orig_sequence = [0, 1, 2, 3, 4, 5, 6, 7, 8]
sequence_middle = []
sequence =[]
sequence_middle[0] = orig_sequence[(orig_sequence.length/2)]

orig_sequence.delete_at(orig_sequence.length/2)
sequence = sequence_middle.concat(orig_sequence)
puts sequence.inspect

root = nil

sequence.each do |item|
  root = insert(root, item) { |value| value <=> sequence_middle[0] }

end
puts("root #{root.inspect}")

#puts " tree is #{root.inspect}"

visit(root, :inorder) do |item|
  puts item.value
end


visit(root, :inorder) do |item|
  puts item.value
  if item.left
    successor = item.left
    puts "the #{item.value} left itemsuccessor is #{successor.value}"
  end
end