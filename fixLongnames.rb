#!/usr/bin/env ruby

require 'component.rb'

require 'yaml'

if ARGV.size != 2
  puts "Usage: fixLongnames [goodYaml] [badYaml]"
  exit
end

goodComponents = YAML::load_file(ARGV[0])
badComponents = YAML::load_file(ARGV[1])

posNames = {}

goodComponents.each do | bag |
  bag.each do | goodPart |
    goodPart.positions.each do | pos |
      posNames[pos] ||= []
      posNames[pos] << goodPart
    end
  end
end

badComponents.values.each do | bag |
  bag.each do | badPart |
    shortNames = {}
    badPart.positions.each do | pos |
      posNames[pos].each do | goodComponent |
        shortNames[goodComponent.longname] ||= 0
        shortNames[goodComponent.longname] += 1
      end
    end
    if (shortNames.keys.size != 1)
      puts "Long name: #{badPart.longname}"
      puts "Funny! shortNames (#{shortNames.keys.size}): #{shortNames.keys} / #{shortNames.values}"
    else
      newname = shortNames.keys[0]
      badPart.longname = newname
      # if badPart.longname.size <= newname.size
        puts "'#{badPart.longname}'   ->   '#{newname}'"
        puts "\t#{badPart.longname.size}   ->   #{newname.size}"
      # end
    end
  end
end

puts " --- "
outfilename = ARGV[1].gsub(".yaml", ".shortnames.yaml")
puts "Saving to '#{outfilename}'"
File.open(outfilename, "w") do | f |
  f.puts(badComponents.to_yaml())
end
puts "... saved."


