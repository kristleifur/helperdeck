#!/usr/bin/env ruby

require 'bag'
require 'component'

require 'yaml'

class BomEat
	def self.eatBom(bomStrings)
	  bags = {}
	  (bomStrings.size / 5).times do | i |
	    thisPartLines = bomStrings[((i*5)..(i*5+4))]
        
	    component = Component.new()

      # component.extraInfo = thisPartLines[0]

	    bagNo = thisPartLines[0].split(" ")[0]# .to_i()
	    # puts "#{bagNo}"
	    if bagNo.to_i().to_s() == bagNo
	      bagNo = bagNo.to_i()
      end
	    
	    # fill component ...
	    component.type = thisPartLines[0].split(" ")[1]
	    
	    component.longname = thisPartLines[1]
      
      component.positions = []
      thisPartLines[2].split(" ")[-1].split(",").each do | pos |
        component.positions << pos
      end
      
      component.comment = thisPartLines[3].gsub("Comment: ", "").strip()
      component.spec = thisPartLines[4].gsub("Spec: ", "").gsub("Spec:", "").strip()
      
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

bags = BomEat.eatBom(File.read(ARGV[0]).split("\n"))
bags.each do | bagname, contents |
  puts "Bag '#{bagname}':"
  File.open("#{ARGV[0]}.bag.#{bagname}.yaml", "w") do | file |
    file.puts contents.to_yaml()
  end
  puts
end


