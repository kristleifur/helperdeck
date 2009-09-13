#!/usr/bin/env shoes

require 'yaml'

require 'Bag'
require 'BoardSide'
require 'Position'
require 'SelectedPosition'
require 'Stage'

def selectComponent(componentName)
  debug componentName
end

class Shoes::App
  def selectComponent(componentName)
    debug "This is the Shoes app. Select component '#{componentName}', a #{componentName.class()}."
  end
end

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
  
  @loadButton = button "Load Board Posn's" do
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
  
  # autoclick
  begin
    debug "Autoload Board Posn's"
    
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

  @@stages = []
  @@stageWindows = []
  @@numberOfStages = 1
  @@numberOfStages.times do | i |
    tmpWin = window :title => "Stage", :width => 250, :height => 300 do
      # ;
    end
    @@stageWindows << tmpWin
    @@stages << BuildStage.new(@@stageWindows[-1], self)
    debug @@stages[0]
    
  end
  @@stages[0].stagename = "Power_in"
  @@stageComponents = {}
  @@stageComponents[@@stages[0].stagename] = @@stages[0].positions
  debug "remember to sync the stageComponents lookup to the board positions post-load"
  tmpStageComponents = %w(d10 d11 c28 r13 c29 r20)
  tmpStageComponents.each do | i |
    if @boardTop.positions[i] == nil && @boardBottom.positions[i] == nil
      debug "#{i} not found on the boards, perhaps new it?"
    else
      pos ||= @boardTop.positions[i]
      pos ||= @boardBottom.positions[i]
      debug "Stages 0:"
      debug @@stages[0]
      debug "Stages 0 positions:"
      debug @@stages[0].positions
      debug "Pos:"
      debug pos
      @@stages[0].positions << pos
    end
  end
  @@stages[0].update()

  # tehBag.components
    
  # @otherWin = window() #  :title => "fufu" do
    # @otherWinStack = stack { para "This is the other window yeah" }
  # end

end

