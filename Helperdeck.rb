#!/usr/bin/env shoes

require 'yaml'

require 'Bag'
require 'BoardSide'
require 'Position'
require 'SelectedPosition'
require 'Stage'

def selectComponent(componentName)
  debug "Warning - helperdeck.selectComponent() called - inactive method"
  debug componentName
end

class Shoes::App
  def clearSelections()
    [@boardTop, @boardBottom, @powerSchematic].each do | boardSide |
      boardSide.selectedPositions.clear()
    end
    @bagControllers.values.each do | bag |
      bag.clearSelection()
    end
	end
  
  def selectPosition(positionNames)
    # debug "This is the Shoes app. Select positions '#{positionNames}', a #{positionNames.class()}."
		positionNames.each do | positionName | 
      # debug "Selecting position '#{positionName}', a #{positionName.class()}"
      # debug positionName
		  [@boardTop, @boardBottom, @powerSchematic].each do | boardSide |
  	    boardSide.selectByName(positionName.downcase().split("-")[0].split("x")[0])
	    end
      # debug @bagControllers
	    @bagControllers.values.each do | bag |
	      bag.selectPosition(positionName.downcase().split("-")[0].split("x")[0])
	    end
		end
	end
end

Shoes.app(:width => 480, :height => 50) do
	Shoes.show_log()
	
  self.class.class_eval do
    attr_accessor :otherWinStack
  end

  @liveComponentWin = window :title => "Selected position", :width => 250, :height => 60 do
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
  # debug "bags: #{@uglyBagModel.keys()}"

  @bagControllers = {}
  @bagWins = {}

  @uglyBagModel.keys.each do | i |
    winHeight = 19 + 21 * (@uglyBagModel[i].size + 1)
    bagWin = window :title => "Bag #{i}, #{@uglyBagModel[i].size} pieces", :width => 340, :height => winHeight do
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

  @stages = []
  @stageWindows = []
  @stageComponents = {}

  @numberOfStages = 5
  @numberOfStages.times do | i |
    tmpWin = window :title => "Stage #{i}", :width => 250, :height => 60 do
      # ;
    end
    @stageWindows << tmpWin
    @stages << BuildStage.new(tmpWin, self)
    # debug @stages[0]
    # @stageComponents[@stages[i].stagename] = @stages[i].positions
  end
  @stages[0].stagename = "Power_in"
  @stages[1].stagename = "8v"
  @stages[2].stagename = "5v"
  @stages[3].stagename = "vpp+14v"
  @stages[4].stagename = "vpp+9v"
  
  debug "Developer note: remember to sync the stageComponents lookup to the board positions post-load"
  tmpStageComponents = {}
  tmpStageComponents[0] = %w(d10 d11 c28 r13 c29 r20)
  tmpStageComponents[1] = %w(d8 r41 c33 r42 q3 d4 c36)
  tmpStageComponents[2] = %w(l5 c41 c37 ic3 r47 c38 r48)
  tmpStageComponents[3] = %w(d9 r44 c34 r45 d5 q4 c35)
  tmpStageComponents[4] = %w(ic2 c10)
  # debug tmpStageComponents
  #   debug tmpStageComponents[0]
  #   debug tmpStageComponents[0].class()
  tmpStageComponents.each do | stageNr, stage |
    # debug "Populating stage '#{stageNr}'"
    stage.each do | i |
      # debug "Looking for position '#{i}'"
      if @boardTop.positions[i] == nil && @boardBottom.positions[i] == nil
        debug "Stage init - warning - position #{i} not found on the board"
      else
        pos ||= @boardTop.positions[i]
        pos ||= @boardBottom.positions[i]
        # debug "Stages 0:"
        # debug @stages[0]
        # debug "Stages 0 positions:"
        # debug @stages[0].positions
        # debug "Pos:"
        # debug pos
        # debug "Putting pos '#{pos}' into @stages[#{stageNr}]"
        @stages[stageNr].positions << pos
      end
    end
    # debug "Updating stage nr. #{stageNr}, name '#{@stages[stageNr].stagename}'"
    @stages[stageNr].update()
  end
  # @stages[0].update()

  # tehBag.components
    
  # @otherWin = window() #  :title => "fufu" do
    # @otherWinStack = stack { para "This is the other window yeah" }
  # end

end

