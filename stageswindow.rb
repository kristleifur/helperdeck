#!/usr/bin/env ruby

require 'stagenowin'

class StagesWindow
  def initialize(win, mainApp, stages_name_to_positions, stagenowin_model)
    @win = win
    @mainApp = mainApp
    @stages_name_to_positions = stages_name_to_positions
    @stagenowin_model = stagenowin_model
    @stacks = {} 
    @stacks_hidden = {}
    @stacks_autohidden = {}
    @bigflow = @win.flow
    @stages_name_to_positions.each do | stagename, stagepositions |
      @stacks_hidden[stagename] = false
      @stacks_autohidden[stagename] = true
    end
    @stagenowin_model.each do | blah |
    end
    update()
  end
  def update()
    @bigflow.clear()
    @bigflow = @win.flow :width => "100%" do
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
          
          stage_link = @win.link "Stage #{stagename} ▼", :stroke => @win.black
          stage_link.click do
            #select all in stage
            @mainApp.clearSelections()
            stage.positions.each do | pos |
              @mainApp.selectPosition(pos.name.downcase().split("-")[0].split("x")[0])
            end
          end
          fold_link = @win.link "BINGBONG #{stage_hidden ? "►" : "▼" }", :underline => "none", :stroke => @win.black
          fold_link.click do
            @stacks_hidden[stagename] = !@stacks_hidden[stagename]
            update()
          end
          if stage_hidden
            linkPara = @win.para stage_link, fold_link
            linkPara.style(:weight => 900) #, :color => "black", :underline => "none")
          else
            linkPara = @win.para stage_link, "\n"
            linkPara.style(:weight => 900)
          end
          if stage_hidden
          else
            position_odd = true
            stage.positions.each_with_index do | position, posIndex |
              str = "#{position.name}"
              tehLink = @win.link str, :stroke => @win.black, :weight => "bold"#, :undercolor = @win.rgb(0.8, 0.8, 0.8)
              if (posIndex != stage.positions.size - 1)
                tehPara = @win.para tehLink , "   |   "
              else
                tehPara = @win.para tehLink
              end
              tehLink.style(:undercolor => @win.rgb(2.0 / 3.0, 0.66, 0.6))

              tehPara.size = "9.5pt"
              if !position_odd
                tehLink.stroke = @win.rgb(0.2, 0.2, 0.2)
              else
                #
              end

              tehLink.click do
                @mainApp.clearSelections()
                pos = position
                # debug "Selecting pos.name: '#{pos.name}'" 
                # stage.positions.each do | pos |
                @mainApp.selectPosition(pos.name.downcase().split("-")[0].split("x")[0])
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
