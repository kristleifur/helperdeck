#!/usr/bin/env ruby

require 'yaml'
require '../../position.rb'

if ARGV.size != 1
  puts "Usage arr2hash.rb [soemthing.yaml]"
  exit
end

array = YAML::load_file(ARGV[0])

hash = {}

array.each do | i |
  hash[i.name] = i 
end

File.open("#{ARGV[0]}.hash.yaml", "w") do | f |
  f.puts hash.to_yaml()
end
