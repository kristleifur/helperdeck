#!/usr/bin/env ruby

require 'bag'
require 'component'

require 'yaml'

class BomEat
	def self.eatBom(bomStrings)
	  bags = []
	  (bomStrings.size / 3).times do | i |
	    thisPartLines = bomStrings[((i*3)..(i*3+2))]
	    component = Component.new()
	    bagNo = thisPartLines[0].split(" ")[0].to_i()
	    
	    # fill component ...
	    component.type = thisPartLines[0].split(" ")[1]
	    
	    component.longname = ""
	    thisPartLines[0].split(" ")[2...(-1)].each do | word |
	      component.longname << "#{word}"
      end
      component.longname.strip()
      
      component.positions = []
      thisPartLines[0].split(" ")[-1].split(",").each do | pos |
        component.positions << pos
      end
      
      component.comment = thisPartLines[1].gsub("Comment: ", "")
      component.spec = thisPartLines[1].gsub("Spec: ", "")
      
      # ... and put it in a bag
	    bags[bagNo] ||= [] 
	    bags[bagNo] << component
    end
    
    return bags
	end
end

bags = BomEat.eatBom(File.read(ARGV[1]).split("\n"))
puts bags.to_yaml()
