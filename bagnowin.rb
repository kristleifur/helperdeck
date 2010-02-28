require 'component'

class BagNoWin
  attr_accessor :id, :positions
  attr_reader :components, :selectedComponents, :has_selected
  def initialize(id = nil)
    @id = id
    @positions = {}
    @selectedComponents = []
    @has_selected = false
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
    @has_selected = false
  end
  def selectPosition(position)
    if (@positions[position.downcase().split("-")[0].split("x")[0]])
      @positions[position.downcase().split("-")[0].split("x")[0]].each do | component |
        unless @selectedComponents.include?(component)
          @selectedComponents << component
          # debug "Found component for #{position}"
        end
      end
      @has_selected = true
    end
  end
end

