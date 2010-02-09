require 'position'
require 'selectedposition'
require 'explodingbox'
require 'yaml'

class Click
  attr_accessor :x, :y
end

class BoardSide
  attr_accessor :positions, :name, :image, :selectedPositions, :hoverPositions, :liveCompBox, :freshName
  def initialize(win, pcbImage, app, selectedPositionWindowHandler)
    @win = win
    @app = app
    @selectedPositionWindowHandler = selectedPositionWindowHandler
    
    @win.stroke @win.orange
    @isturquoise = true
    @win.strokewidth 2
    @win.nofill
    # @pcbImage = pcbImage
    @pcbImageName = pcbImage
    @pcbImage = @win.image pcbImage
    # @win.height = 40 # @pcbImage.height
    # @win.width = 80 # @pcbImage.width
    @positions = {} # hash of name to location (?)
    @selectedPositions = []
    @hoverPositions = []
    # @xRangeStarts = {} # ouch, we gotta be smarter than this, use a sorted array or tree or sth
    # @xRangeEnds = {} #TODO: un-slow click detection
    # @yRangeStarts = {}
    # @yRangeEnds = {}
    @buttons = {}
    @theClick = Click.new
    @liveString = ""
    
    @freshName = false
    
    @explodingBoxes = []
    
    @win.keypress do | key |
      # @liveString << key.to_s()
      if (@selectedPositions.size() == 1)
        if key == "\n"
          @freshName = true
          debug "Key is newline, setting #@freshName to true"
          # debug "Clearing live string"
          # @liveString.delete!(@liveString)
        else
          if (freshName)
            debug "@freshName is true ... deleting name"
            @selectedPositions[0].name.delete!(@selectedPositions[0].name)
            @selectedPositions[0].name << key.to_s() # @liveString.dup()
            @selectedPositionWindowHandler.update()
          else
            @selectedPositions[0].name << key.to_s()
            @selectedPositionWindowHandler.update()
          end
          @freshName = false
        end
      end
      # @liveCompBox.text = @liveString.dup()
      
    end
    
    @win.animate(10) do
      @win.clear()
      @win.image @pcbImageName
      @win.stroke @win.yellow
      @explodingBoxes.each do | box |
        box.step()
        if box.done?()
          @explodingBoxes.delete(box)
        else 
          @win.rect :left => box.x, :top => box.y, :width => box.width, :height => box.height
        end
      end
      if @tehPos && @tehPos.width > 0 && @tehPos.height > 0
        @win.rect :left => @tehPos.left, :top => @tehPos.top, :width => @tehPos.width, :height => @tehPos.height
      end
      @win.stroke @win.purple
      @hoverPositions.each do | pos |
        @win.rect :left => pos.left(), :width => pos.width(), :top => pos.top(), :height => pos.height()
      end
      @win.stroke @win.orange
      @positions.values.each do | pos |
        # debug "POS: #{pos.inspect()}"
        if @selectedPositions.include?(pos) # && @hoverPositions.include?(pos)
          @win.strokewidth 4.5
          @win.stroke @win.turquoise
          # debug "L: " + pos.left().inspect() + ", W:" +  pos.width().inspect() + ", T: " +  pos.top().inspect() + ", H: " + pos.height().inspect()
          @win.rect :left => pos.left(), :width => pos.width(), :top => pos.top(), :height => pos.height()
          @win.stroke @win.orange
          @win.strokewidth 2
        elsif @hoverPositions.include?(pos)
           @win.stroke @win.purple
            # debug "L: " + pos.left().inspect() + ", W:" +  pos.width().inspect() + ", T: " +  pos.top().inspect() + ", H: " + pos.height().inspect()
            @win.rect :left => pos.left(), :width => pos.width(), :top => pos.top(), :height => pos.height()
            @win.stroke @win.orange
        else
          if (pos.name == "")
            @win.stroke @win.deeppink
            @win.rect :left => pos.left(), :width => pos.width(), :top => pos.top(), :height => pos.height()
            @win.stroke @win.orange
          else
            @win.rect :left => pos.left(), :width => pos.width(), :top => pos.top(), :height => pos.height()
          end
        end
      end
      # @selectedPositions
    end
    
    drawMode()
  end
  
  def getPositionsAt(x, y)
    foundPositions = []
    @positions.values.each do | pos |
      if (pos.left <= x && pos.top <= y && pos.left + pos.width >= x && pos.top + pos.height >= y)
        # debug "Found something: #{pos.to_yaml()}"
        foundPositions << pos
      end
    end
    return foundPositions
  end
  
  def drawMode()
    @win.click do | button, x, y |
      @selectededPositions = []
      @buttons[button] = true
      @theClick.x = x
      @theClick.y = y
      @tehPos = Position.new(:left => x, :top => y, :width => 1, :height => 1)
    end
    @win.release do | button, x, y |
      if @buttons[1] && button == 1 && @tehPos && @tehPos.width > 0 && @tehPos.height > 0
        @tehPos.left = [@theClick.x, x].min
        @tehPos.top = [@theClick.y, y].min
        @tehPos.width = (@theClick.x - x).abs()
        @tehPos.height = (@theClick.y - y).abs()
        @positions[(positions.size() + 1).to_s()] = @tehPos
      end
      @buttons[button] = false
    end
    @win.motion do | x, y |
      if @buttons[1]
        @tehPos.left = [@theClick.x, x].min
        @tehPos.top = [@theClick.y, y].min
        @tehPos.width = (@theClick.x - x).abs()
        @tehPos.height = (@theClick.y - y).abs()
      else
        @hoverPositions = []
        @positions.values.each do | pos |
          if (pos.left <= x && pos.top <= y && pos.left + pos.width >= x && pos.top + pos.height >= y)
            # debug "Found something: #{pos.to_yaml()}"
            @hoverPositions << pos
          end
        end
      end
    end
    
    @drawMode = true
    @selectMode = false
  end
  
  def selectMode()
    @win.click do | button, x, y |
      # debug "BS Click"
      @buttons[button] = true
      @theClick.x = x
      @theClick.y = y
      
      allHaveNames = true
      
      @selectedPositions = []
      @positions.values.each do | pos |
        if (pos.left <= x && pos.top <= y && pos.left + pos.width >= x && pos.top + pos.height >= y)
          # debug "Found something: #{pos.to_yaml()}"
          @selectedPositions << pos
          debug "in-board selection code; pos: #{pos}"
          if (!pos.name || pos.name == "")
            debug "allHaveNames = false, shouldn't call selectByName in parent"
            allHaveNames = false
          end
        end
      end
      
      if (allHaveNames)
        # puts "Calling selectByName in parent ... (?)"
        allNames = []
        selectedPositions.each do | selPos |
          allNames << selPos.name()
        end
        @app.clearSelections()
        @app.selectPosition(allNames) # hmm weird
      end
      
      # @liveCompBox.text = ""
      if (@selectedPositions.size == 1)
        @selectedPositionWindowHandler.livePosition = @selectedPositions[0]
        @selectedPositionWindowHandler.update()
        @liveString.delete!(@liveString)
        @liveString << @selectedPositions[0].name
      else
        @selectedPositionWindowHandler.livePosition = nil
        @selectedPositionWindowHandler.update()
        @liveString.delete!(@liveString)
      end
      # @selectedPositions.each do | selPos |
      #         # debug(selPos.inspect())
      #         # @liveCompBox.text = selPos.inspect()
      #         # debug "@selectedPositionWindowHandler:"
      #         # debug @selectedPositionWindowHandler.class
      #         # debug @selectedPositionWindowHandler.inspect
      #         # debug @selectedPositionWindowHandler.methods
      #         # debug "\n"
      #         @selectedPositionWindowHandler.livePosition = selPos
      #       end
    end
    @win.release do | button, x, y |
      # debug "BS Release"
      if button == 1 && @buttons[button]
        @selectedPositions = []
        selectedPosNames = []
        allHaveNames = true
        @positions.values.each do | pos |
          if (pos.left <= x && pos.top <= y && pos.left + pos.width >= x && pos.top + pos.height >= y)
            # debug "Found something: #{pos.to_yaml()}"
            @selectedPositions << pos
            selectedPosNames << pos.name
            if (!pos.name || pos.name == "")
              allHaveNames = false
            end
          end
        end
        if (allHaveNames)
          @app.clearSelections()
          @app.selectPosition(selectedPosNames) # hmm weird
        end
      end
      @buttons[button] = false
    end
    @win.motion do | x, y |
      @hoverPositions = []
      @positions.values.each do | pos |
        if (pos.left <= x && pos.top <= y && pos.left + pos.width >= x && pos.top + pos.height >= y)
          # debug "Found something: #{pos.to_yaml()}"
          @hoverPositions << pos
        end
      end 
      if @buttons[1]
        @selectedPositions = []
        @positions.values.each do | pos |
          if (pos.left <= x && pos.top <= y && pos.left + pos.width >= x && pos.top + pos.height >= y)
            # debug "Found something: #{pos.to_yaml()}"
            @selectedPositions << pos
          end
        end
      end
    end
    
    # @win.animate(4) do
    #   # 
    # end
    
    @selectMode = true
    @drawMode = false
  end
  
  def selectByName(positionName)
    # debug "BS selectByName:"
    # debug positionName
    if @positions[positionName]
      # debug "Found it"
      # debug "positionName found on board #{@pcbImage}"
      tehPos = @positions[positionName]
      @selectedPositions << @positions[positionName]
      @explodingBoxes << ExplodingBox.new(tehPos.x, tehPos.y, tehPos.width, tehPos.height)
    end
  end
  
  def updateRanges(newPosition = nil)
    #TODO: un-slow click detection / octree-style array-sorted-by-ranges type of stfff
  end
  
  def addPosition(x, y, name)
    @positions[name] ||= []
    @positions[name] << Position.new(x, y)
    updateRanges(@positions[name])
    return @positions[name]
  end
end

