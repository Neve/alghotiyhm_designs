require './binarytree'

include BinaryTree

$root = nil
%w{Implement an algorithm to determine if a string has all unique characters  What if you can not use additional data structures}.each do |word|
  if $root.nil?
    $root = Node.new(word)
  else
    $root.insert(Node.new(word))
  end
end

$root.each do |node|
  puts "#{node.word} (#{node.count})"
end

puts
puts "#{$root.size} words."
puts "#{$root.count_all} nodes."