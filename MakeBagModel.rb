#!/usr/bin/env ruby

require 'yaml'

require 'component'

bags = File.open(ARGV[0]) { |stream| YAML::load(stream) }

# puts bags.to_yaml()
puts "Bags:"
bags.keys.sort().each do |bagNo|
  puts "\t#{bagNo}"
end
puts

positions = {}

bags.each do | bagNo, componentList |
  componentList.each do | component |
    puts "\t" + component.longname()
    component.positions.each do | pos |
      puts "\t\t" + pos.inspect()
      positions[pos] ||= {}
      positions[pos][bagNo] ||= []
      positions[pos][bagNo] << component.dup()
    end
  end
end

puts positions.to_yaml()