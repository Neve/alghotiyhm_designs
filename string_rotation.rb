s1 = "waterbottle"
s2 = "erbottlewat"

def is_rotation (s1, s2)
  if (s1.length > 0 && s1.length == s2.length)
    s1s1 = s1+s1
    #waterbottlewaterbottle
    #   erbottlewat
    if s1s1.index(s2)
      puts s1s1
    else
      puts "s2 is not substring of s1"
    end
  end
end

is_rotation(s1, s2)