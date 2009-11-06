#!/usr/bin/env ruby

if ARGV != 2
  puts "Usage: fixLongnames [goodYaml] [badYaml]"
end

goodComponents = YAML::load_file(ARGV[0])
badComponents = YAML::load_file(ARGV[1])

posNames = {}

goodComponents.each do | goodPart |
  goodPart.positions.each do | pos |
    posNames[pos] ||= []
    posNames[pos] << goodPart
  end
end

badComponents.each do | badPart |
  puts "Long name: #{badPart.longname}"
  puts "Short name(s):"
  badPart.positions.each do | pos |
    posNames[pos].each do | goodComponent |
      puts goodComponent.longname
    end
  end
end