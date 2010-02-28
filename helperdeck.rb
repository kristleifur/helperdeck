#!/usr/bin/env shoes

require 'yaml'

require 'bag'
require 'boardside'
require 'position'
require 'selectedposition'
require 'stage'
require 'bagswindow'

def selectComponent(componentName)
  debug "Warning - helperdeck.selectComponent() called - inactive method"
  # debug componentName
end

class Shoes::App
  def clearSelections()
    @boards.each do | boardSide |
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
		  @boards.each do | boardSide |
  	    boardSide.selectByName(positionName.downcase().split("-")[0].split("x")[0])
	    end
      # debug @bagControllers
	    @bagControllers.values.each do | bag |
	      bag.selectPosition(positionName.downcase().split("-")[0].split("x")[0])
	    end
		end
	end
	
	def loadDatapack(datapackName)
	  debug "Loading '#{datapackName}'"
	  @bagControllers ||= {}
    @bagWins ||= {}
    @boards ||= []
    @boardsToFilenames ||= {}
    @bag_contents ||= {}
	  datapackFiles = Dir["datapacks/#{datapackName}.helperdeck/*"]
	  datapackFiles.each do | file |
	    if File.directory?(file)
        # debug "#{file} is a directory"
	      if file =~ /bags$/
          # debug "Bags dir found"
	        bagDirContents = Dir["#{file}/*"]
          # debug bagDirContents
          # @bagControllers ||= {}
          #           @bagWins ||= {}
          bagDirContents.each do | bagFile |
            bagName = bagFile.split("/")[-1].gsub(".yaml", "")
            # debug "Bag name: '#{bagName}', loading ..."
            bagContents = YAML::load_file(bagFile)
            # debug bagContents
            # debug "... loaded bag."
            
            winHeight = 19 + 21 * (bagContents.size + 1)
            bagWin = window :title => "Bag #{bagName}, #{bagContents.size} pieces", :width => 340, :height => winHeight do
              #
            end
            @bagWins[bagName] = bagWin
            tehBag = Bag.new(bagWin, self, "#{bagName}")
            tehBag.components = bagContents
            @bag_contents[bagName] = tehBag.components.dup()
            
            @bagControllers[bagName] = tehBag
            tehBag.update()
          end
        end
        if file =~ /build_stages$/
          # debug "Build-stages dir found"
          @stageDirContents = Dir["#{file}/*"].sort()
          # debug @stageDirContents
        end
      else
        # debug "#{file} is a file"
        # debug file.inspect()
        # debug file.class()
        if file.include?(".yaml")
          # debug "#{file} is YAML"
          imagename = file.gsub(".yaml", ".png")
          if (datapackFiles.include?(imagename))
            # debug "found matching image"
            # @boards ||= []
            wintitle = ""
            file.split("/")[(-2)..(-1)].each do | bit |
              wintitle << "#{bit}/"
            end
            wintitle.gsub!(".yaml/", "").gsub!(".helperdeck", "")
            imgsize = imagesize(imagename)
            width = imgsize[0]
            height = imgsize[1]
            # debug "Image width: #{imgsize[0]}, height: #{imgsize[1]}"

            boardWin = window :title => wintitle, :width => width, :height => height do
            end
            tehBoard = BoardSide.new(boardWin, imagename, self, @selectedPosition)
            # debug "Load Board Posn's"
            freshPositions = YAML.load_file(file)
            tehBoard.positions = {}
            if freshPositions
              freshPositions.values.each do | i |
                if (tehBoard.positions[i.name])
                  debug "Warning: position #{i.name} is duplicated"
                end
                tehBoard.positions[i.name] = i
              end
            else
              # puts "WARNING: No position info found in '#{file}'"
            end
            @boards << tehBoard
            # @boardsToFilenames ||= {}
            @boardsToFilenames[tehBoard] = file
          else
            debug "Image not found for '#{file}', ignoring"
          end
        else
          #poff
        end
	    end
    end
    if @stageDirContents
      @stages = []
      @stageWindows = []
      @stageComponents = {}

      @numberOfStages = @stageDirContents.size
    
      tmpStageComponents = {}
    
      @numberOfStages.times do | i |
        tmpWin = window :title => "Stage #{i + 1}", :width => 250, :height => 60 do
          # ;
        end
        @stageWindows << tmpWin
        @stages << BuildStage.new(tmpWin, self)
        # debug @stages[0]
        # @stageComponents[@stages[i].stagename] = @stages[i].positions
      
        @stages[i].stagename = @stageDirContents[i].split("/")[-1].gsub(".txt","")
        tmpStageComponents[i] = File.read(@stageDirContents[i]).strip().split(" ")
        # debug tmpStageComponents[i]
      end

      # debug "Developer note: remember to sync the stageComponents lookup to the board positions post-load"
      # debug tmpStageComponents
      #   debug tmpStageComponents[0]
      #   debug tmpStageComponents[0].class()
      tmpStageComponents.each do | stageNr, stage |
        # debug "Populating stage '#{stageNr}'"
        stage.each do | i |
          i.downcase!()
          # debug "Looking for position '#{i}'"
          foundOnBoards = false
          @boards.each do | board |
            if (board.positions[i])
              foundOnBoards = true
            end
          end
          if (!foundOnBoards)
            debug "Stage init - warning - position #{i} not found on the board"
          else
            pos = nil
            @boards.each do | board |
              # debug board.positions.to_yaml()
              if board.positions[i]
                pos ||= board.positions[i]
                # debug "Got pos from board? - pos is '#{pos.to_yaml()}'"
                # debug "Onboard we have '#{board.positions[i].to_yaml}' ... ?"
              end
            end
            # pos ||= @boardBottom.positions[i]
            # debug "Stages 0:"
            # debug @stages[0]
            # debug "Stages 0 positions:"
            # debug @stages[0].positions
            # debug "Pos:"
            # debug pos
            # debug "Putting pos '#{pos}' into @stages[#{stageNr}]"
            if (pos)
              @stages[stageNr].positions << pos
            end
          end
        end
        # debug "Updating stage nr. #{stageNr}, name '#{@stages[stageNr].stagename}'"
        @stages[stageNr].update()
      end
      # @stages[0].update
    else
      debug "Stage dir contents are none ... hmm"
    end
    # tmpWin = window :title => "Stage #{i + 1}", :width => 250, :height => 60 do
    @bags_window_window = window do end
    @bagnowin_model = {}
    @bag_contents.each do | bagname, bag_contents |
      @bagnowin_model[bagname] = BagNoWin.new(bagname)
      @bagnowin_model[bagname].components = bag_contents
    end
    @bags_window = BagsWindow.new(@bags_window_window, self, @bag_contents, @bagnowin_model)
  end
end

Shoes.app(:width => 480, :height => 50) do
	Shoes.show_log()
	
	@liveComponentWin = window :title => "Selected position", :width => 250, :height => 60 do
  end
  @selectedPosition = SelectedPosition.new(@liveComponentWin, self)
  
	# loadDatapack("amp32")
  loadDatapack("amp4")
  # loadDatapack("amp15-ps")
 
  # @uglyBagModel = YAML::load_file("Amp15_BagsAndComponents.yaml")
  #   # debug "bags: #{@uglyBagModel.keys()}"
  # 
  #   @bagControllers = {}
  #   @bagWins = {}
  # 
  #   @uglyBagModel.keys.each do | i |
  #     winHeight = 19 + 21 * (@uglyBagModel[i].size + 1)
  #     bagWin = window :title => "Bag #{i}, #{@uglyBagModel[i].size} pieces", :width => 340, :height => winHeight do
  #       #
  #     end
  #     @bagWins[i] = bagWin
  #     tehBag = Bag.new(bagWin, self, "#{i}")
  #     tehBag.components = @uglyBagModel[i]
  #     @bagControllers[i] = tehBag
  #     tehBag.update()
  #   end
  
  button "DRAW" do
    debug "Entering Draw mode"
    @boards.each do | board |
      board.drawMode()
    end
  end
  
  button "SELECT" do
    debug "Entering select mode"
    @boards.each do | board |
      board.selectMode()
    end
  end
  
  @boards.each do | board |
    board.selectMode()
  end
  
  button "Save Board Posn's" do
    debug "Save Board Posn's - [beta code!]"
    @boards.each do |board|
      componentYaml = board.positions.to_yaml()
      yamlFilename = @boardsToFilenames[board]
      File.open(yamlFilename, "w") do | f |
        f.puts componentYaml
      end
    end
        # componentYaml = @boardTop.positions.to_yaml()
        #         # debug componentYaml
        #         File.open("boardTop.dump.yaml", "w") do | f |
        #           f.puts componentYaml
        #         end
        #         componentYaml = @boardBottom.positions.to_yaml()
        #         # debug componentYaml
        #         File.open("boardBottom.dump.yaml", "w") do | f |
        #           f.puts componentYaml
        #         end
        #         debug "Saved"
        #     componentYaml = @powerSchematic.positions.to_yaml()
        #     File.open("PowerSchematic.dump.yaml", "w") do | f |
        #       f.puts componentYaml
        #     end
  end
  
  @loadButton = button "Load Board Posn's" do
    debug "Load button triggered - no functionality!"
    # debug "Load Board Posn's
    #     freshPositions = YAML.load_file("boardTop.dump.yaml")
    #     @boardTop.positions = {}
    #     freshPositions.values.each do | i |
    #       if (@boardTop.positions[i.name])
    #         debug "position #{i.name} is duplicated"
    #       end
    #       @boardTop.positions[i.name] = i
    #     end
    #     
    #     # @boardTop.positions = YAML.load_file("boardTop.dump.yaml")
    #     @boardTop.selectedPositions.clear()
    #     @boardTop.hoverPositions.clear()
    #     
    #     freshPositions = YAML.load_file("boardBottom.dump.yaml")
    #     @boardBottom.positions = {}
    #     freshPositions.values.each do | i |
    #       if (@boardBottom.positions[i.name])
    #         debug "position #{i.name} is duplicated"
    #       end
    #       @boardBottom.positions[i.name] = i
    #     end
    #     
    #     # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    #     @boardBottom.selectedPositions.clear()
    #     @boardBottom.hoverPositions.clear()
    # 
    #     freshPositions = YAML.load_file("PowerSchematic.dump.yaml")
    #     @powerSchematic.positions = {}
    #     freshPositions.values.each do | i |
    #       if (@powerSchematic.positions[i.name])
    #         debug "position #{i.name} is duplicated"
    #       end
    #       @powerSchematic.positions[i.name] = i
    #     end
    #     
    #     # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    #     @powerSchematic.selectedPositions.clear()
    #     @powerSchematic.hoverPositions.clear()
    # 
    #     debug "Loaded"
  end
  
  # autoclick
  begin
    # debug "Autoload Board Posn's"
    #     
    #     freshPositions = YAML.load_file("boardTop.dump.yaml")
    #     @boardTop.positions = {}
    #     freshPositions.values.each do | i |
    #       if (@boardTop.positions[i.name])
    #         debug "position #{i.name} is duplicated"
    #       end
    #       @boardTop.positions[i.name] = i
    #     end
    #     
    #     # @boardTop.positions = YAML.load_file("boardTop.dump.yaml")
    #     @boardTop.selectedPositions.clear()
    #     @boardTop.hoverPositions.clear()
    #     
    #     freshPositions = YAML.load_file("boardBottom.dump.yaml")
    #     @boardBottom.positions = {}
    #     freshPositions.values.each do | i |
    #       if (@boardBottom.positions[i.name])
    #         debug "position #{i.name} is duplicated"
    #       end
    #       @boardBottom.positions[i.name] = i
    #     end
    #     
    #     # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    #     @boardBottom.selectedPositions.clear()
    #     @boardBottom.hoverPositions.clear()
    #     
    #     freshPositions = YAML.load_file("PowerSchematic.dump.yaml")
    #     @powerSchematic.positions = {}
    #     freshPositions.values.each do | i |
    #       if (@powerSchematic.positions[i.name])
    #         debug "position #{i.name} is duplicated"
    #       end
    #       @powerSchematic.positions[i.name] = i
    #     end
    #     
    #     # @boardBottom.positions = YAML.load_file("boardBottom.dump.yaml")
    #     @powerSchematic.selectedPositions.clear()
    #     @powerSchematic.hoverPositions.clear()
    #     
    #     debug "Loaded"
    # 
    #     debug "Entering select mode"
    #     @boardTop.selectMode()
    #     @boardBottom.selectMode()
    #     @powerSchematic.selectMode()
  end
  
  @selectedPosition = nil # Position.new() #TODO: fix / use / toss

  # @stages = []
  #  @stageWindows = []
  #  @stageComponents = {}
  # 
  #  @numberOfStages = 5
  #  @numberOfStages.times do | i |
  #    tmpWin = window :title => "Stage #{i}", :width => 250, :height => 60 do
  #      # ;
  #    end
  #    @stageWindows << tmpWin
  #    @stages << BuildStage.new(tmpWin, self)
  #    # debug @stages[0]
  #    # @stageComponents[@stages[i].stagename] = @stages[i].positions
  #  end
  #  @stages[0].stagename = "Power_in"
  #  @stages[1].stagename = "8v"
  #  @stages[2].stagename = "5v"
  #  @stages[3].stagename = "vpp+14v"
  #  @stages[4].stagename = "vpp+9v"
  #  
  #  debug "Developer note: remember to sync the stageComponents lookup to the board positions post-load"
  #  tmpStageComponents = {}
  #  tmpStageComponents[0] = %w(d10 d11 c28 r13 c29 r20)
  #  tmpStageComponents[1] = %w(d8 r41 c33 r42 q3 d4 c36)
  #  tmpStageComponents[2] = %w(l5 c41 c37 ic3 r47 c38 r48)
  #  tmpStageComponents[3] = %w(d9 r44 c34 r45 d5 q4 c35)
  #  tmpStageComponents[4] = %w(ic2 c10)
  #  # debug tmpStageComponents
  #  #   debug tmpStageComponents[0]
  #  #   debug tmpStageComponents[0].class()
  #  tmpStageComponents.each do | stageNr, stage |
  #    # debug "Populating stage '#{stageNr}'"
  #    stage.each do | i |
  #      # debug "Looking for position '#{i}'"
  #      if @boardTop.positions[i] == nil && @boardBottom.positions[i] == nil
  #        debug "Stage init - warning - position #{i} not found on the board"
  #      else
  #        pos ||= @boardTop.positions[i]
  #        pos ||= @boardBottom.positions[i]
  #        # debug "Stages 0:"
  #        # debug @stages[0]
  #        # debug "Stages 0 positions:"
  #        # debug @stages[0].positions
  #        # debug "Pos:"
  #        # debug pos
  #        # debug "Putting pos '#{pos}' into @stages[#{stageNr}]"
  #        @stages[stageNr].positions << pos
  #      end
  #    end
  #    # debug "Updating stage nr. #{stageNr}, name '#{@stages[stageNr].stagename}'"
  #    @stages[stageNr].update()
  #  end
  # @stages[0].update()

  # tehBag.components

end


