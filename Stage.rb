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
    @posFlow = @stageWin.stack() do 
      @stageWin.para "Positions: "
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
    @posFlow = @stageWin.stack() do 
      @stageWin.para "Positions: "
      @@positions.each do | pos |
        @stageWin.para pos.name()
      end
    end
  end
end
