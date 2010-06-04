#!/usr/bin/env ruby

require 'bag'
require 'component'

require 'yaml'

class SimpleBomEat
	def self.eatBom(bomStrings)
	  bags = {}
	  bomStrings.each do | bigLine |
	    line = bigLine.split("\t")
        
	    component = Component.new()

      # component.extraInfo = line[0]

	    bagNo = line[0] #??.split(" ")[0]# .to_i()

	    if bagNo.to_i().to_s() == bagNo
	      bagNo = bagNo.to_i()
      end
	    
	    # fill component ...
	    component.type = "" # line[0].split(" ")[1]
	    
	    component.longname = "#{line[4]} - #{line[3]}"
      component.longname.strip!()
      
      component.positions = []
      line[2].split(",").each do | pos |
        component.positions << pos
      end
      
      component.comment = line[4] #.gsub("Comment: ", "").strip()
      component.spec = line[3] # line[2].gsub("Spec: ", "").strip()
      
      # ... and put it in a bag
	    bags[bagNo] ||= [] 
	    bags[bagNo] << component
    end
    
    return bags
	end
end

if ARGV.size != 1
	puts "Usage: bomEat.rb [41hz-amp-bom.txt]"
	exit
end

bags = SimpleBomEat.eatBom(File.read(ARGV[0]).split("\n"))
bags.each do | bagname, contents |
  puts "Bag '#{bagname}':"
  File.open("#{ARGV[0]}.bag.#{bagname}.yaml", "w") do | file |
    file.puts contents.to_yaml()
  end
  puts
end
# puts bags.to_yaml()
# puts bags.keys()

