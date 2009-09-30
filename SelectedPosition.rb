class SelectedPosition
  attr_accessor :liveComponentBox
  attr_reader :livePosition
  def initialize(liveComponentWin, mainApp)
    # debug "BLAH"
    # debug self.inspect()
    @liveComponentWin = liveComponentWin
    @mainApp = mainApp
    # debug mainApp.inspect()
    @liveComponentWin.para "Name"
    @nameLine = @liveComponentWin.edit_line do | e |
      @livePosition.name = e.text
    end
  end
  def livePosition=(position)
    # debug "SelectedPosition.livePosition="
    @livePosition = position
    update()
  end
  def update()
    @nameLine.text = @livePosition.name if @livePosition
  end
end
