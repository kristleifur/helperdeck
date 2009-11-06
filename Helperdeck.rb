#!/usr/bin/env shoes

require 'yaml'

require 'Bag'
require 'BoardSide'
require 'Position'
require 'SelectedPosition'
require 'Stage'

def selectComponent(componentName)
  # debug componentName
end

class Shoes::App
  def clearSelections()
    [@boardTop, @boardBottom, @powerSchematic].each do | boardSide |
      boardSide.selectedPositions.clear()
    end
	end
  
  def selectPosition(positionNames)
    # debug "This is the Shoes app. Select position '#{positionName}', a #{positionName.class()}."
		positionNames.each do | positionName | 
      # debug "Selecting position ..."
      # debug positionName
		  [@boardTop, @boardBottom, @powerSchematic].each do | boardSide |
  	    boardSide.selectByName(positionName)
	    end
		end
	end
end

Shoes.app(:width => 480, :height => 50) do
	Shoes.show_log()
	
  self.class.class_eval do
    attr_accessor :otherWinStack
  end

  @liveComponentWin = window :title => "Selected position", :width => 250, :height => 250 do
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
  
	@powerSchematicImageFilename = "PowerSchematic.png"
	@powerSchematicWin = window :title => @powerSchematicImageFilename, :width => 644, :height => 240 do
		# do window stuff eh?
	end
	@powerSchematic = BoardSide.new(@powerSchematicWin, @powerSchematicImageFilename, self, @selectedPosition)

  @uglyBagModel = YAML::load_file("Amp15_BagsAndComponents.yaml")
  debug "bags: #{@uglyBagModel.keys()}"

  @bagControllers = {}
  @bagWins = {}

  @uglyBagModel.keys.each do | i |
    winHeight = 32 * (@uglyBagModel[i].size + 1)
    bagWin = window :title => "Bag #{i}, #{@uglyBagModel[i].size} pieces", :width => 310, :height => winHeight do
      #
    end
    @bagWins[i] = bagWin
    tehBag = Bag.new(bagWin, self, "#{i}")
    tehBag.components = @uglyBagModel[i]
    @bagControllers[i] = tehBag
    tehBag.update()
  end
  
  button "DRAW" do
    debug "Enter Draw"
    @boardTop.drawMode()
    @boardBottom.drawMode()
		@powerSchematic.drawMode()
  end
  
  button "SELECT" do
    debug "Entering select mode"
    @boardTop.selectMode()
    @boardBottom.selectMode()
		@powerSchematic.selectMode()
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
		componentYaml = @powerSchematic.positions.to_yaml()
		File.open("PowerSchematic.dump.yaml", "w") do | f |
			f.puts componentYaml
		end
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

		freshPositions = YAML.load_file("PowerSchematic.dump.yaml")
    @powerSchematic.positions = {}
    freshPositions.values.each do | i |
      if (@powerSchematic.positions[i.name])
        debug "position #{i.name} is duplicated"
      end
      @powerSchematic.positions[i.name] = i
    end
    
    # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    @powerSchematic.selectedPositions.clear()
    @powerSchematic.hoverPositions.clear()

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
    
    freshPositions = YAML.load_file("PowerSchematic.dump.yaml")
    @powerSchematic.positions = {}
    freshPositions.values.each do | i |
      if (@powerSchematic.positions[i.name])
        debug "position #{i.name} is duplicated"
      end
      @powerSchematic.positions[i.name] = i
    end
    
    # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    @powerSchematic.selectedPositions.clear()
    @powerSchematic.hoverPositions.clear()
		
    debug "Loaded"

    debug "Entering select mode"
    @boardTop.selectMode()
    @boardBottom.selectMode()
		@powerSchematic.selectMode()
  end
  
  @selectedPosition = nil # Position.new() #TODO: fix / use / toss

  @@stages = []
  @@stageWindows = []
  @@numberOfStages = 1
  @@numberOfStages.times do | i |
    tmpWin = window :title => "Stage", :width => 250, :height => 300 do
      # ;
    end
    @@stageWindows << tmpWin
    @@stages << BuildStage.new(@@stageWindows[-1], self)
    # debug @@stages[0]
    
  end
  @@stages[0].stagename = "Power_in"
  @@stageComponents = {}
  @@stageComponents[@@stages[0].stagename] = @@stages[0].positions
  debug "Developer note: remember to sync the stageComponents lookup to the board positions post-load"
  tmpStageComponents = %w(d10 d11 c28 r13 c29 r20)
  tmpStageComponents.each do | i |
    if @boardTop.positions[i] == nil && @boardBottom.positions[i] == nil
      debug "#{i} not found on the boards, perhaps new it?"
    else
      pos ||= @boardTop.positions[i]
      pos ||= @boardBottom.positions[i]
      # debug "Stages 0:"
      # debug @@stages[0]
      # debug "Stages 0 positions:"
      # debug @@stages[0].positions
      # debug "Pos:"
      # debug pos
      @@stages[0].positions << pos
    end
  end
  @@stages[0].update()

  # tehBag.components
    
  # @otherWin = window() #  :title => "fufu" do
    # @otherWinStack = stack { para "This is the other window yeah" }
  # end

end

