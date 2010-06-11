#!/usr/bin/env ruby

require 'stagenowin'

class StagesWindow
  def initialize(win, mainApp, stages_name_to_positions, stagenowin_model)
    @win = win
    @mainApp = mainApp
    @stages_name_to_positions = componenthashes
    @stagenowin_model = stagenowin_model
    @stacks = {} 
    @stacks_hidden = {}
    @stacks_autohidden = {}
    @bigflow = @win.flow
    @stages_name_to_positions.each do | stagename, stagepositions |
      @stacks_hidden[stagename] = false
      @stacks_autohidden[stagename] = true
    end
    @autoflow = false
    update()
  end
  def update()
    # debug "bagswindow update"
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
      @stagenowin_model.keys().sort().each do | stagename |
        stage = @stagenowin_model[stagename]
        @stacks[stagename].clear() if @stacks[stagename]
        @stacks[stagename] = @win.flow() do
          stage_hidden = nil
          if @autoflow
            stage_hidden = !@stagenowin_model[stagename].has_selected
          else
            stage_hidden = @stacks_hidden[stagename]
          end
          
          link = @win.link "Stage #{stagename} #{stage_hidden ? "►" : "▼" }", :underline => "none", :stroke => @win.black
          link.click do
            @stacks_hidden[stagename] = !@stacks_hidden[stagename]
            update()
          end
          if stage_hidden
            linkPara = @win.para link #, "\n"
            linkPara.style(:weight => 900) #, :color => "black", :underline => "none")
          else
            linkPara = @win.para link, "\n"
            linkPara.style(:weight => 900)
          end
          # BAG SPECIFIC STILL:
          # if @stagenowin_model[stagename].has_selected
          #   link.style(:underline => "single")
          #   linkPara.style(:undercolor => @win.red)
          # end
          if stage_hidden
          else
            position_odd = true
            stage.positions.each_with_index do | positions, posIndex |
              str = "#{position.name}"
              positions = positions.dup()
              # component.positions.size.times do | i |
              #   if (i == 0)
              #     str << ": "
              #   end
              #   str << "#{component.positions[i]}"
              #   if (component.positions.size > 1 && i != component.positions.size - 1)
              #     str << ", " 
              #   end
              # end
              tehLink = @win.link str, :stroke => @win.black, :weight => "bold"#, :undercolor = @win.rgb(0.8, 0.8, 0.8)
              if (compIndex != stage.positions.size - 1)
                tehPara = @win.para tehLink , "   |   "
              else
                tehPara = @win.para tehLink
              end
              tehLink.style(:undercolor => @win.rgb(2.0 / 3.0, 0.66, 0.6))

              tehPara.size = "9.5pt"
              if !position_odd
                tehLink.stroke = @win.rgb(0.2, 0.2, 0.2)
                # tehPara.style(:undercolor => @win.white) # :background => @win.red, 
              else
                # tehLink.style(:underline => "double") # :fill => @win.red) #{}"darkgray") # :underline => "double") #:weight => "bold") #:undercolor => @win.turquoise) # :background => @win.blue, 
              end
              
              # if (bag.selectedComponents.include?(component))
              #   tehLink.style(:fill => @win.white)                
              #   tehLink.style(:underline => "error")
              #   tehLink.style(:undercolor => @win.turquoise)
              #   tehLink.style(:stroke => @win.black)
              #   if !position_odd
              #     # tehLink.style(:weight => 900, :fill => @win.white, :stroke => @win.darkblue) #, :background => @win.white) # 900 is ultrabold (bold is 800)
              #   else
              #     # tehLink.style(:weight => "bold", :fill => @win.white, :stroke => @win.darkblue) #, :background => @win.black) # 900 is ultrabold (bold is 800)
              #   end
              # end
              tehLink.click do
                @mainApp.clearSelections()
                positions.each do | pos |
                  @mainApp.selectPosition(pos.downcase().split("-")[0].split("x")[0])
                end
              end
              position_odd = !position_odd
            end
          end
        end
      end
    end
  end
end
