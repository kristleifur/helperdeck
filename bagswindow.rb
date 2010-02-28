#!/usr/bin/env ruby

require 'bagnowin'

class BagsWindow
  def initialize(win, mainApp, componenthashes, bagnowin_model)
    @win = win
    @mainApp = mainApp
    @componenthashes = componenthashes
    @bagnowin_model = bagnowin_model
    @componenthashes.each do | x, y |
      debug x.to_yaml()
      debug y.to_yaml()
    end
    @stacks = {} 
    @stacks_hidden = {}
    @bigflow = @win.flow
    @componenthashes.each do | bagname, bag |
      @stacks_hidden[bagname] = false
    end
    reflow()
  end
  def reflow()
    @bigflow.clear()
    @bigflow = @win.flow :width => "100%" do
      @bagnowin_model.keys().sort().each do | bagname |
        bag = @bagnowin_model[bagname]
        @stacks[bagname].clear() if @stacks[bagname]
        @stacks[bagname] = @win.flow do
          link = @win.link "Bag #{bagname}"
          link.click do
            @stacks_hidden[bagname] = !@stacks_hidden[bagname]
            reflow()
          end
          linkPara = @win.para link, "\n"
          # @win.flow :width => "100%" do
            # linkPara.size = "xx-large"
            
            if @stacks_hidden[bagname]
            else
              # @win.flow() do 
              #   titlePara = @win.para("Bag #{bagname}")
              #   titlePara.size = "large"
              # end

              bag.components.each_with_index do | component, compIndex |
                # @win.flow() do
                  str = "#{component.longname}"
                  positions = component.positions.dup()
                  component.positions.size.times do | i |
                    if (i == 0)
                      str << ": "
                    end
                    str << "#{component.positions[i]}"
                    if (component.positions.size > 1 && i != component.positions.size - 1)
                      str << ", " 
                    end
                  end
                  tehLink = @win.link str
                  if (compIndex != bag.components.size - 1)
                    tehPara = @win.para tehLink , "   |   "
                  else
                    tehPara = @win.para tehLink
                  end
                  if (bag.selectedComponents.include?(component))
                    tehLink.style(:weight => 900, :fill => @win.turquoise) # 900 is ultrabold (bold is 800)
                  end
                  tehPara.size = "x-small"
                  tehLink.click do
                    # debug tehPara.inspect()
                    @mainApp.clearSelections()
                    positions.each do | pos |
                      # debug "sel #{pos}"
                      @mainApp.selectPosition(pos.downcase().split("-")[0].split("x")[0])
                    end
                  end
                # end
              end
            end
          end
      end
    end
  end
end
