require 'component'

class BagNoWin
  attr_accessor :id, :positions
  attr_reader :components, :selectedComponents
  def initialize(id = nil)
    @id = id
    @positions = {}
    @selectedComponents = []
  end
  def components=(components)
    @components = components
    @positions ||= {}
    @positions.clear()
    @components.each do | comp |
      comp.positions.each do | compPos |
        @positions[compPos.downcase().split("-")[0].split("x")[0]] ||= []
        @positions[compPos.downcase().split("-")[0].split("x")[0]] << comp
      end
    end
  end
  def clearSelection()
    if (@selectedComponents.size > 0)
      @selectedComponents.clear()
    end
  end
  def selectPosition(position)
    if (@positions[position.downcase().split("-")[0].split("x")[0]])
      @positions[position.downcase().split("-")[0].split("x")[0]].each do | component |
        unless @selectedComponents.include?(component)
          @selectedComponents << component
          # debug "Found component for #{position}"
        end
      end
    end
  end
end

