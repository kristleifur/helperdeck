#!/usr/bin/env ruby

require 'stagenowin'

class AllComponentsWindow
  def initialize(win, mainApp, allPositions_byFirstCharacter)
    @win = win
    @mainApp = mainApp
    @allPositions_byFirstCharacter = allPositions_byFirstCharacter
    # @stagenowin_model = stagenowin_model
    @stacks = {} 
    @stacks_hidden = {}
    @stacks_autohidden = {}
    @bigflow = @win.flow
    @allPositions_byFirstCharacter.each do | firstcharacter, positions |
      # @win.para "#{stagename}"
      @stacks_hidden[firstcharacter] = false
      @stacks_autohidden[firstcharacter] = true
    end
    # @stagenowin_model.each do | blah |
    #       # debug blah.inspect
    #     end
    # @autoflow = false
    update()
  end
  def update()
    # debug "bagswindow update"
    @bigflow.clear()
    @bigflow = @win.flow :width => "100%" do
      # @win.flow do
      #   flow_check = @win.check
      #   flow_check.click do
      #     @autoflow = !@autoflow
      #     update()
      #   end
      #   flow_check.checked = @autoflow
      #   flow_link = @win.link "Autoflow"
      #   flow_link.click do
      #     @autoflow = !@autoflow
      #     update()
      #   end
      #   flow_para = @win.para flow_link
      #   flow_para.style(:size => "xx-small", :weight => "bold")
      # end
      @allPositions_byFirstCharacter.keys().sort().each do | firstLetter |
        # @win.para "stagename: #{stagename}"
        positions_under_letter = @allPositions_byFirstCharacter[firstLetter]
        @stacks[firstLetter].clear() if @stacks[firstLetter]
        @stacks[firstLetter] = @win.flow() do
          stage_hidden = nil
          # if @autoflow
          #   stage_hidden = !@stagenowin_model[firstLetter].has_selected
          # else
            stage_hidden = @stacks_hidden[firstLetter]
          # end
          
          stage_link = @win.link "#{firstLetter}... ▼", :stroke => @win.black
          stage_link.click do
            #select all in stage
            @mainApp.clearSelections()
            positions_under_letter.each do | pos |
              @mainApp.selectPosition(pos.downcase().split("-")[0].split("x")[0])
            end
          end
          fold_link = @win.link "BINGBONG #{stage_hidden ? "►" : "▼" }", :underline => "none", :stroke => @win.black
          fold_link.click do
            @stacks_hidden[firstLetter] = !@stacks_hidden[firstLetter]
            update()
          end
          if stage_hidden
            linkPara = @win.para stage_link, fold_link
            linkPara.style(:weight => 900) #, :color => "black", :underline => "none")
          else
            linkPara = @win.para stage_link, "\n"
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
            positions_under_letter.each_with_index do | position, posIndex |
              str = "#{position}"
              # positions = positions.dup()
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
              if (posIndex != positions_under_letter.size - 1)
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
                pos = position
                # debug "Selecting pos: '#{pos}'" 
                # positions_under_letter.each do | pos |
                @mainApp.selectPosition(pos.downcase().split("-")[0].split("x")[0])
                # end
              end
              position_odd = !position_odd
            end
          end
        end
      end
    end
  end
end
