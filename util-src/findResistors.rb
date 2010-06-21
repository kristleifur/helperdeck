#!/usr/bin/env ruby

if ARGV.size == 0
  puts "Usage: findComponents.rb [baginputfile.yaml]"
  exit
end

matches = {}
value_matches = {}

ARGV.each do | infilename |

  # infilename = ARGV[0]

  res_regex_1 = /[0-9]+(\.|\,)?[0-9]*([km])?(ohm)/ix
  res_regex_2 = /x{0}[0-9]+r[0-9]*/ix
  rexes = []
  rexes << res_regex_1
  rexes << res_regex_2

  antirexes = []
  antirexes << /x7r/ix

  lines = File.read(infilename).split("\n")
  lines.each_with_index do | line, i |
    rexes.each do | rex |
      if ((line =~ rex))
        m1 = rex.match(line)
        # puts "Line matches #{m1.size} times:"
        # puts "\t'#{line}'"
        m1.size.times do | i |
          # puts "#{i}: #{m1[i]}"
          antirexes.each do | antirex |
            if ((m1[i] =~ rex) && !(m1[i] =~ antirex) && !line.downcase().include?("x7r"))
              matches[m1[i].downcase.gsub("ohm", "")] ||= []
              amp_and_bag = infilename.gsub("datapacks/", "").gsub(".helperdeck/", "").gsub("bags/", ", bag ").gsub(".yaml", "")
              matches[m1[i].downcase.gsub("ohm", "")] << "#{amp_and_bag} - #{line}"
              # puts "\t#{m1[i]}"
              # ((-10)..10).each do | line_i |
                # puts lines[line_i]
              # end
            end
          end
        end
      end
    end
  end
end

matches.each do | key, value |
  result_float = 0.0
  puts "Matches for '#{key}':"
  value.each do | line |
    puts "\t#{line}"
  end
  puts "key.to_f: #{key.to_f()}"
  if /r/i.match(key)
    puts "Key has 'R' or 'r'"
    r_float = key.downcase.gsub("r", ".").to_f()
    result_float = r_float
    # puts "R-fixed key.to_f: #{r_float}"
  elsif /k/i.match(key)
    puts "Key has ~kilo~"
    teh_float = key.to_f()
    teh_float *= 1e3
    result_float = teh_float
    puts "kilo-fixed key.to_f: #{teh_float}" 
  elsif /m/i.match(key)
    puts "Key has ~mega~"
    teh_float = key.to_f()
    teh_float *= 1e6
    result_float = teh_float
    # puts "mega-fixed key.to_f: #{teh_float}" 
  else
    puts "Key has neither R, K, or M".upcase
    puts key
    result_float = key.to_f()
  end
  if result_float != 0.0
    value_matches[result_float] ||= []
    value.each do | line |
      value_matches[result_float] << line
    end
  end
  puts ""
end

value_matches.keys.sort.each do | key |
  value = value_matches[key]
  puts "Resistor value '#{key}' matches:"
  value.each do | line |
    puts "\t#{line}"
  end
end