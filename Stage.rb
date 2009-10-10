class BuildStage
  attr_accessor :positions, :stagename
  # attr_reader :livePosition
  def initialize(stageWin, mainApp)
    # debug "BLAH"
    # debug self.inspect()
    @stageWin = stageWin
    @mainApp = mainApp
    @stagename = ""
    @positions = []
    @@positions = @positions #TODO: arrgh fix global / class member dubbl

    # debug mainApp.inspect()
    @nameFlow = @stageWin.flow() do | flow |
      @stageWin.para "Stage:"
      @stageWin.edit_line ""
    end
    @posFlow = @stageWin.flow() do 
      @stageWin.stack do
        @stageWin.para "Positions: "
        @stageWin.click do
          # debug "Clicked the 'Positions' stack"
          @@positions.each do | pos |
            # debug "\tPos: #{pos}"
            @mainApp.selectPosition(pos.name)
          end
        end
      end
      @@positions.each do | pos |
        @stageWin.para << pos.name()
      end
    end
    # @nameLine = @liveComponentWin.edit_line do | e |
    #       @livePosition.name = e.text
    #     end
  end
  # def livePosition=(position)
  #     # debug "SelectedPosition.livePosition="
  #     # @livePosition = position
  #     #     update()
  #   end
  def update()
    @nameFlow.clear()
    @nameFlow = @stageWin.flow() do | flow |
      @stageWin.para "Stage:"
      line = @stageWin.edit_line
      line.text = @stagename
    end
    @posFlow.clear()
    @posFlow = @stageWin.flow() do 
      @stageWin.stack() do
        @stageWin.para @stageWin.link("Positions:")
        @stageWin.click do
          # debug "Clicked the 'Positions' stack"
          @mainApp.clearSelections()
          posNames = []
          @@positions.each do | pos |
            posNames << pos.name()
          end
          # debug "Selecting ..."
          @mainApp.selectPosition(posNames)
          # @@positions.each do | pos |
          #   @mainApp.clearSelections()
          #   @mainApp.selectPosition(pos.name)
          # end
        end
      end
      @stageWin.stack() do
        @@positions.each do | pos |
          @stageWin.stack() do
            tehPara = @stageWin.para pos.name()
            @stageWin.click do
              # debug tehPara.inspect()
              @mainApp.clearSelections()
              @mainApp.selectPosition(tehPara.text())
            end
          end
        end
      end
    end
  end
end
