Cell = Struct.new(:value, :next)

list = Cell.new("head ho", nil)

def linked_list(value, cell)
  return Cell.new(value, cell)
end

def recursive_print(list)
  puts list[:value]
  recursive_print(list.next) unless list.next == nil
end

def remove_entry(entry, list)
  next_ent = list.next
  if list.value == entry
    list.next = next_ent.next
    list.value = next_ent.value
  end
  remove_entry(entry, list.next) unless list.next == nil
end

for i in 1 .. 5
  list = linked_list(i, list)
end

for i in 1 .. 4
  list = linked_list(i, list)
end

recursive_print(list)

def deduplicate_with_buffer(input_list, buffer_hash = Hash.new("defult"), uniq_hash = Hash.new("defult"))
  tmp = buffer_hash.has_key?(input_list.value)
  puts "#{tmp} -> #{input_list.value}"

  if buffer_hash.has_key?(input_list.value)
    puts "duplicate found #{input_list.value}"
    uniq_hash[input_list.value] = input_list.value
  else
    buffer_hash[input_list.value] = input_list.value
    puts buffer_hash.inspect
  end
  deduplicate_with_buffer(input_list.next, buffer_hash, uniq_hash) unless input_list.next == nil
  return uniq_hash
end

duplicates = deduplicate_with_buffer(list)

duplicates.each_value { |value| remove_entry(value, list) }

#remove_entry(10, list)


#puts list

recursive_print(list)
