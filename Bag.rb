class Bag
  attr_accessor :components, :id #, :notes
  def initialize(win, id = nil)
    @win = win
    @win.append { @win.para "bla in bag" }
    # @components = {} # hash of component -> count ... e.g. components[SomeResistorValue] == 5
    @id = id
    @positions = {}
    # @notes = [] #TODO: add notes - like maybe an array of notes-strings
  end
end
