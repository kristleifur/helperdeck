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
    debug "SelectedPosition.livePosition="
    debug position
    debug position.name
    @livePosition = position
    update()
  end
  def update()
    debug "selectedposition.rb:"
    debug @livePosition
    debug @livePosition.name
    @nameLine.text = @livePosition.name if @livePosition
  end
end

