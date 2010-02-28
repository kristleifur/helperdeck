#!/usr/bin/env ruby

require 'bag'

class BagsWindow
  def initialize(win, bagmodel)
    @win = win
    @bagmodel = bagmodel
    @stacks = {} 
    @stacks_hidden = {}
    @bigflow = @win.stack do
      bagmodel.each do | bagname, bag |
        # debug bagname
        # debug bag.to_yaml()
        @stacks_hidden[bagname] = true
        @stacks[bagname] = @win.flow :width => "1" do
          link = @win.link bagname
          link.click do
            if @stacks_hidden[bagname]
              @stacks[bagname].width = "100%"
              @stacks[bagname].height = "100%"
              debug "stack (#{@stacks[bagname].width} x #{@stacks[bagname].height})"
            else
              @stacks[bagname].width = "1"
              @stacks[bagname].height = "1"
              debug "stack (#{@stacks[bagname].width} x #{@stacks[bagname].height})"
            end
            @stacks_hidden[bagname] = !@stacks_hidden[bagname]
          end
          @win.para link
          # @win.para "Lorem ipsum constituet sic dolor argadrg adgr adrg adrg adrg adrgar\n `oregEOPS;GIPOEJSG LOLOLL" #bag.to_yaml().split("\n")[0...3]
          "Lorem ipsum constituet sic dolor argadrg adgr adrg adrg adrg adrgar\n `oregEOPS;GIPOEJSG LOLOLL".split(" ").each do |pg|
            @win.para pg
          end
        end
      end
    end
  end
end
