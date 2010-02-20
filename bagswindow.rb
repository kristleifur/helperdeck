#!/usr/bin/env ruby

require 'bag'

class BagsWindow
  def initialize(win, bagmodel)
    @win = win
    @bagmodel = bagmodel
    @bigflow = @win.flow # do | flow |
    @stacks = {} 
    bagmodel.each do | bagname, bag |
      @stacks[bagname] = @win.stack do | stack |
        link = @win.link "POFF"
        link.click do
          @win.animate(10) do 
            # debug "Po"
            @stacks[bagname].height -= 3
          end
          
          debug "gliggs"
          # @stacks[bagname]= @win.stack do | stack |
          #   @win.para "poff"
          # end
        end
        @win.para link
        @win.para bag.to_yaml().split("\n")[0...3]
      end
    end
  end
end
