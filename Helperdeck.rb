#!/usr/bin/env shoes

require 'yaml'

require 'Bag'
require 'BoardSide'
require 'Position'
require 'SelectedPosition'

Shoes.app(:width => 480, :height => 320) do
	Shoes.show_log()
	
  self.class.class_eval do
    attr_accessor :otherWinStack
  end

  @liveComponentWin = window :title => "Selected component", :width => 250, :height => 250 do
    # @@liveComponentBox = edit_box
  end
  # debug @liveComponentWin.inspect()
  @selectedPosition = SelectedPosition.new(@liveComponentWin, self)

  @boardTopImageFilename = "amp15top_858x537.png"
  @boardWin = window :title => @boardTopImageFilename, :width => 858, :height => 537 do
    # do window stuff eh?
  end
  @boardTop = BoardSide.new(@boardWin, @boardTopImageFilename, self, @selectedPosition)
  
  @boardBottomImageFilename = "amp15bottom_858x537.png"
  @boardBottomWin = window :title => @boardBottomImageFilename, :width => 858, :height => 537 do
    # do window stuff eh?
  end
  @boardBottom = BoardSide.new(@boardBottomWin, @boardBottomImageFilename, self, @selectedPosition)
  
  # @bagWin = window :title => "Bags maybe" do
  #   para "bags???"
  # end
  # 
  # @bags = {}
  # 
  # tehBag = Bag.new(@bagWin) # new()
  # @bags[0] = tehBag
  
  button "DRAW" do
    debug "Enter Draw"
    @boardTop.drawMode()
    @boardBottom.drawMode()
  end
  
  button "SELECT" do
    debug "Enter Select"
    @boardTop.selectMode()
    @boardBottom.selectMode()
  end
  
  button "Save Board Posn's" do
    debug "Save Board Posn's"
    componentYaml = @boardTop.positions.to_yaml()
    # debug componentYaml
    File.open("boardTop.dump.yaml", "w") do | f |
      f.puts componentYaml
    end
    componentYaml = @boardBottom.positions.to_yaml()
    # debug componentYaml
    File.open("boardBottom.dump.yaml", "w") do | f |
      f.puts componentYaml
    end
    debug "Saved"
  end
  
  button "Load Board Posn's" do
    debug "Load Board Posn's"
    freshPositions = YAML.load_file("boardTop.dump.yaml")
    @boardTop.positions = {}
    freshPositions.values.each do | i |
      if (@boardTop.positions[i.name])
        debug "position #{i.name} is duplicated"
      end
      @boardTop.positions[i.name] = i
    end
    
    # @boardTop.positions = YAML.load_file("boardTop.dump.yaml")
    @boardTop.selectedPositions.clear()
    @boardTop.hoverPositions.clear()
    
    freshPositions = YAML.load_file("boardBottom.dump.yaml")
    @boardBottom.positions = {}
    freshPositions.values.each do | i |
      if (@boardBottom.positions[i.name])
        debug "position #{i.name} is duplicated"
      end
      @boardBottom.positions[i.name] = i
    end
    
    # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    @boardBottom.selectedPositions.clear()
    @boardBottom.hoverPositions.clear()
    debug "Loaded"
  end
  
  @selectedPosition = nil # Position.new()

  # tehBag.components
    
  # @otherWin = window() #  :title => "fufu" do
    # @otherWinStack = stack { para "This is the other window yeah" }
  # end

end

