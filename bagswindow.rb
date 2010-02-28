#!/usr/bin/env ruby

require 'bagnowin'

class BagsWindow
  def initialize(win, mainApp, componenthashes, bagnowin_model)
    @win = win
    @mainApp = mainApp
    @componenthashes = componenthashes
    @bagnowin_model = bagnowin_model
    @stacks = {} 
    @stacks_hidden = {}
    @stacks_autohidden = {}
    @bigflow = @win.flow
    @componenthashes.each do | bagname, bag |
      @stacks_hidden[bagname] = false
      @stacks_autohidden[bagname] = true
    end
    @autoflow = false
    update()
  end
  def update()
    @bigflow.clear()
    @bigflow = @win.flow :width => "100%" do
      @win.flow do
        flow_check = @win.check
        flow_check.click do
          @autoflow = !@autoflow
          update()
        end
        flow_check.checked = @autoflow
        flow_link = @win.link "Autoflow"
        flow_link.click do
          @autoflow = !@autoflow
          update()
        end
        flow_para = @win.para flow_link
        flow_para.style(:size => "xx-small", :weight => "bold")
      end
      @bagnowin_model.keys().sort().each do | bagname |
        bag = @bagnowin_model[bagname]
        @stacks[bagname].clear() if @stacks[bagname]
        @stacks[bagname] = @win.flow() do
          bag_hidden = nil
          if @autoflow
            bag_hidden = !@bagnowin_model[bagname].has_selected
          else
            bag_hidden = @stacks_hidden[bagname]
          end
          
          link = @win.link "Bag #{bagname} #{bag_hidden ? "►" : "▼" }"
          link.click do
            @stacks_hidden[bagname] = !@stacks_hidden[bagname]
            update()
          end
          if bag_hidden
            linkPara = @win.para link #, "\n"
            linkPara.style(:weight => 900)
          else
            linkPara = @win.para link, "\n"
            linkPara.style(:weight => 900)
          end
          if @bagnowin_model[bagname].has_selected
            linkPara.style(:undercolor => @win.red)
          end
          # @win.flow :width => "100%" do
          # linkPara.size = "xx-large"
            
          if bag_hidden
          else
            # @win.flow() do 
            #   titlePara = @win.para("Bag #{bagname}")
            #   titlePara.size = "large"
            # end

            component_odd = true
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
                if !component_odd
                  tehLink.style(:weight => 900, :fill => @win.turquoise) #, :background => @win.white) # 900 is ultrabold (bold is 800)
                else
                  tehLink.style(:weight => 900, :fill => @win.turquoise) #, :background => @win.black) # 900 is ultrabold (bold is 800)
                end
              end
              tehPara.size = "x-small"
              if !component_odd
                # tehPara.style(:undercolor => @win.white) # :background => @win.red, 
              else
                tehPara.style(:weight => "bold") #:undercolor => @win.turquoise) # :background => @win.blue, 
              end
              tehLink.click do
                # debug tehPara.inspect()
                @mainApp.clearSelections()
                positions.each do | pos |
                  # debug "sel #{pos}"
                  @mainApp.selectPosition(pos.downcase().split("-")[0].split("x")[0])
                end
              end
              component_odd = !component_odd
            end
          end
        end
      end
    end
  end
end
