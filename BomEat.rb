#!/usr/bin/env ruby

require 'bag'
require 'component'

require 'yaml'

class BomEat
	def self.eatBom(bomStrings)
	  bags = {}
	  (bomStrings.size / 3).times do | i |
	    thisPartLines = bomStrings[((i*3)..(i*3+2))]
        
	    component = Component.new()

      component.extraInfo = thisPartLines[0]

	    bagNo = thisPartLines[0].split(" ")[0]# .to_i()
	    # puts "#{bagNo}"
	    if bagNo.to_i().to_s() == bagNo
	      bagNo = bagNo.to_i()
      end
	    
	    # fill component ...
	    component.type = thisPartLines[0].split(" ")[1]
	    
	    component.longname = ""
	    thisPartLines[0].split(" ")[2...(-1)].each do | word |
	      component.longname << "#{word} "
      end
      component.longname.strip!()
      
      component.positions = []
      thisPartLines[0].split(" ")[-1].split(",").each do | pos |
        component.positions << pos
      end
      
      component.comment = thisPartLines[1].gsub("Comment: ", "").strip()
      component.spec = thisPartLines[2].gsub("Spec: ", "").strip()
      
      # ... and put it in a bag
	    bags[bagNo] ||= [] 
	    bags[bagNo] << component
    end
    
    return bags
	end
end

bags = BomEat.eatBom(File.read(ARGV[0]).split("\n"))
puts bags.to_yaml()
# puts bags.keys()
