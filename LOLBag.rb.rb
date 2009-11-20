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
      # debug comp
      comp.positions.each do | compPos |
        @positions[compPos.downcase().split("-")[0].split("x")[0]] ||= []
        @positions[compPos.downcase().split("-")[0].split("x")[0]] << comp
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
  def clearSelection()
    if (@selectedComponents.size > 0)
      @selectedComponents.clear()
      update()
    end
  end
  def selectPosition(position)
    # debug "Selecting components for position #{position} in bag #{id}"
    shouldUpdate = false
    if (@positions[position.downcase().split("-")[0].split("x")[0]])
      @positions[position.downcase().split("-")[0].split("x")[0]].each do | component |
        unless @selectedComponents.include?(component)
          @selectedComponents << component
          # debug "Found component for #{position}"
          shouldUpdate = true
        end
      end
    end
    if (shouldUpdate)
      # debug "Should be updating ..."
      update()
    end
  end
  def update()
    # debug "Updating bag #{id}"
    @nameFlow.clear()
    @nameFlow = @win.flow() do 
      titlePara = @win.para("Bag #{id}")
      titlePara.size = "large"
    end
    @componentFlow.clear()
    @componentFlow = @win.flow() do
      @components.each_with_index do | component, compIndex |
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
          tehLink = @win.link str
          if (compIndex != @components.size - 1)
            tehPara = @win.para tehLink, "\n"
          else
            tehPara = @win.para tehLink
          end
          if (@selectedComponents.include?(component))
            tehLink.style(:weight => 900, :fill => @win.turquoise) # 900 is ultrabold (bold is 800)
          end
          tehPara.size = "x-small"
          tehLink.click do
            # debug tehPara.inspect()
            @mainApp.clearSelections()
            positions.each do | pos |
              # debug "sel #{pos}"
              @mainApp.selectPosition(pos.downcase().split("-")[0].split("x")[0])
            end
          end
        # end
      end
    end
  end
end

