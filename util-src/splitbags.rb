#!/usr/bin/env ruby

require 'yaml'

if ARGV.size != 1
  puts "Usage: splitBags.rb [multibag.yaml]"
  exit
end

allBags = YAML::load_file(ARGV[0])

allBags.each do | bagname, bagstuff |
  puts "bag '#{bagname}' ..."
  # puts bagstuff.to_yaml
  # puts
  # puts "----------"
  # puts
  filename = "#{bagname}.yaml"
  puts "\tFilename: '#{filename}'"
  File.open(filename, "w") do | file |
    file << bagstuff.to_yaml()
  end
  puts "... saved."
  puts
end
