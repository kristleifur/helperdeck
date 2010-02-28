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
    debug "bagswindow update"
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
          
          link = @win.link "Bag #{bagname} #{bag_hidden ? "►" : "▼" }", :underline => "none", :stroke => @win.black
          # link.underline = "none"
          # link.underline("none")
          link.click do
            @stacks_hidden[bagname] = !@stacks_hidden[bagname]
            update()
          end
          if bag_hidden
            linkPara = @win.para link #, "\n"
            linkPara.style(:weight => 900) #, :color => "black", :underline => "none")
            # linkPara.underline = "none"
          else
            linkPara = @win.para link, "\n"
            linkPara.style(:weight => 900)
            # linkPara.fill = @win.red #{}"none"
            # linkPara.
          end
          if @bagnowin_model[bagname].has_selected
            link.style(:underline => "single")
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
              tehLink = @win.link str, :stroke => @win.black, :weight => "bold"#, :undercolor = @win.rgb(0.8, 0.8, 0.8)
              # tehLink.style(:weight => "bold")
              if (compIndex != bag.components.size - 1)
                tehPara = @win.para tehLink , "   |   "
              else
                tehPara = @win.para tehLink
              end
              tehLink.style(:undercolor => @win.rgb(2.0 / 3.0, 0.66, 0.6))
              

              tehPara.size = "9.5pt"
              # tehPara.weight = "900"
              if !component_odd
                tehLink.stroke = @win.rgb(0.2, 0.2, 0.2)
                # tehPara.style(:undercolor => @win.white) # :background => @win.red, 
              else
                # tehLink.style(:underline => "double") # :fill => @win.red) #{}"darkgray") # :underline => "double") #:weight => "bold") #:undercolor => @win.turquoise) # :background => @win.blue, 
              end
              
              if (bag.selectedComponents.include?(component))
                tehLink.style(:fill => @win.white)                
                tehLink.style(:underline => "error")
                tehLink.style(:undercolor => @win.turquoise)
                tehLink.style(:stroke => @win.black)
                if !component_odd
                  # tehLink.style(:weight => 900, :fill => @win.white, :stroke => @win.darkblue) #, :background => @win.white) # 900 is ultrabold (bold is 800)
                else
                  # tehLink.style(:weight => "bold", :fill => @win.white, :stroke => @win.darkblue) #, :background => @win.black) # 900 is ultrabold (bold is 800)
                end
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
