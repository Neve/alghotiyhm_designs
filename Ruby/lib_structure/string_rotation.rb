# Assume you have a method isSubstring which checks if one word is a substring of another Given two strings, s1 and s2, write code to check if s2 is a rotation of s1 using only one call to isSubstring (i e , “waterbottle” is a rotation of “erbottlewat”) 

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