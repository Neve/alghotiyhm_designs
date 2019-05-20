class Node
  attr_accessor :value, :left, :right

  def initialize(value = nil, left = nil, right = nil)
    @value, @left, @right = value, left, right
  end
end

def insert(node, v, &block)
  return Node.new(v) if not node
  case block[v, node.value]
  when -1
    node.left = insert(node.left, v, &block)
  when 1
    node.right = insert(node.right, v, &block)
  end
  return node
end

# Visit receives the order that the nodes should be visited as well as a block that will act as a visitor of the stored values.
# This function is also implemented in terms of itself.

def visit(n, order = :preorder, &block)
  return false unless (n != nil)

  case order
  when :preorder
    yield n.value
    visit(n.left, order, &block)
    visit(n.right, order, &block)
  when :inorder
    visit(n.left, order, &block)
    yield n.value
    visit(n.right, order, &block)
  when :postorder
    visit(n.left, order, &block)
    visit(n.right, order, &block)
    yield n.value
  end

end

root = nil
"chunkybacon".scan(/./m) { |symbol| root = insert(root, symbol) { |a, b| a<=>b } }

visit(root, :postorder) { |leaf| puts leaf }








