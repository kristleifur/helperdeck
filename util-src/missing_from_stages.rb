#!/usr/bin/env ruby

require 'yaml'

require '../../component'
require '../../position'

bags = []

Dir["bags/*.yaml"].each do | file |
  bags << YAML::load_file(file)
  # ### puts bags[-1].inspect
end

boards = []

positions = {}

Dir["*.yaml"].each do | file |
  boards << YAML::load_file(file)
  # ### puts boards[-1].inspect
  # ### puts boards[-1].keys.to_yaml()
  boards[-1].values.each do | position |
    positions[position.name] = position
  end
end

# ### puts positions.to_yaml()

posCopy = positions.dup()

stages = []

Dir["build_stages/*"].each do | file |
  ### puts file
  stages << YAML::load_file(file)
  if stages[-1]
    # ### puts stages[-1].split(" ").to_yaml()
    stages[-1].split(" ").each do | pos |
      if posCopy.include?(pos)
        ### puts "#{pos} found, deleting"
      else
        ### puts "#{pos} NOT found ..."
      end
      posCopy.delete(pos)
      # ### puts "#{pos}?: #{positions[pos]}"
    end
  else
    # ### puts "[[ '#{file}' is empty ]]"
  end
end

### puts "posCopy.size(): #{posCopy.size()}"
### puts "positions.size(): #{positions.size()}"

# puts posCopy.to_yaml()

# puts bags.to_yaml()

hmt = []
smt = []
other = []

bags.each do | bag |
  # puts bag.to_yaml()
  bag.each do | part |
    part.positions.each do | position |
      position.downcase!()
      if (posCopy[position])
        puts "#{position} type is missing from stages - type #{part.type}"
        if part.type.include?("smt")
          smt << position
        elsif part.type.include?("hmt")
          hmt << position
        else
          other << position
        end
        # puts part.to_yaml()
      end
      if (positions[position])
        # puts "#{position} is in the positions, yeah"
      end
    end
  end
end

puts "smt:"
puts smt.to_yaml
puts
puts "hmt:"
puts hmt.to_yaml()
puts
puts "other:"
puts other.to_yaml()
puts

