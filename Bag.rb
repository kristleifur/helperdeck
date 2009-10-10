require 'component'

class Bag
  attr_accessor :id, :positions #, :notes
  attr_reader :components, :selectedComponents
  def initialize(win, mainApp, id = nil)
    @win = win
    @mainApp = mainApp
    @nameFlow = @win.flow() do 
      @win.para("Bag #{id}")
    end
    @componentFlow = @win.stack() do 
      #
    end
    # @components = {} # hash of component -> count ... e.g. components[SomeResistorValue] == 5
    @id = id
    @positions = {}
    @selectedComponents = []
    # @notes = [] #TODO: add notes - like maybe an array of notes-strings
  end
  def components=(components)
    @components = components
    @positions ||= {}
    @positions.clear()
    @components.each do | comp |
      debug comp
      comp.positions.each do | compPos |
        @positions[compPos] ||= []
        @positions[compPos] << comp
      end
    end
  end
  # def selectComponent(component)
  #   if components.include?(component)
  #     unless @selectedComponents.include?(component)
  #       @selectedComponents << component
  #     end
  #   end
  # end
  def selectPosition(position)
    @positions[position].each do | component |
      unless @selectedComponents.include?(component)
        @selectedComponents << component
      end
    end
  end
  def update()
    @nameFlow.clear()
    @nameFlow = @win.para("Bag #{id}")
    @componentFlow.clear()
    @componentFlow = @win.flow() do
      @components.each do | component |
        @win.stack() do
          str = "#{component.longname}"
          positions = component.positions.dup()
          component.positions.size.times do | i |
            if (i == 0)
              str << ": #{component.positions[i]}" 
            elsif (i == component.positions.size - 1)
              str << "#{component.positions[i]}"
            else
              str << "#{component.positions[i]}, "
            end
          end
          tehPara = @win.para str
          @win.click do
            # debug tehPara.inspect()
            @mainApp.clearSelections()
            positions.each do | pos |
              debug "sel #{pos}"
              @mainApp.selectPosition(pos.downcase())
            end
          end
        end
      end
    end
  end
end
