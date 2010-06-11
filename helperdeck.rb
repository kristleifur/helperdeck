#!/usr/bin/env ruby

require 'yaml'

require 'bag'
require 'boardside'
require 'position'
require 'selectedposition'
require 'stage'
require 'bagswindow'
require 'stageswindow'
require 'stagenowin'

def selectComponent(componentName)
  debug "Warning - helperdeck.selectComponent() called - inactive method"
  # debug componentName
end

class Shoes::App
  attr_accessor :datapacks
  def clearSelections()
    @boards.each do | boardSide |
      boardSide.selectedPositions.clear()
    end
    # @bagControllers.values.each do | bag |
    #   bag.clearSelection()
    # end
    @bagnowin_model.values.each do | bag |
      bag.clearSelection()
    end
    @bags_window.update()
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
      # @bagControllers.values.each do | bag |
      #   bag.selectPosition(positionName.downcase().split("-")[0].split("x")[0])
      # end
	    @bagnowin_model.values.each do | bag |
	      bag.selectPosition(positionName.downcase().split("-")[0].split("x")[0])
      end
		end
		@bags_window.update()
	end
	
	def findDatapacks(dirname = "")
	  @datapacks ||= []
	  @datapacks.clear()
		if (dirname == "")
			dirname = Dir.getwd()
		end
		dirname += "/datapacks"
		debug "Looking for .helperdeck datapacks in '#{dirname}'"
		Dir[dirname + "/*.helperdeck"].each do | helperdeck_dir |
		  debug "Found #{helperdeck_dir}"
		  @datapacks << helperdeck_dir
	  end
	end
	
	def loadDatapack(datapackName)
	  
  	@liveComponentWin = window :title => "Selected position", :width => 250, :height => 60 do
    end
    @selectedPosition = SelectedPosition.new(@liveComponentWin, self)
    debug "@selectedPosition created"
    
	  
	  debug "Loading '#{datapackName}'"
	  # @bagControllers ||= {}
	  @bagnowin_model = {}
	  @stagenowin_model = {}
    @bagWins ||= {}
    @boards ||= []
    @boardsToFilenames ||= {}
    @bag_contents ||= {}
    @stage_name_to_positions ||= {}
	  datapackFiles = Dir["#{datapackName}/*"]# Dir["datapacks/#{datapackName}.helperdeck/*"]
	  datapackFiles.each do | file |
	    debug file
	    if File.directory?(file)
        # debug "#{file} is a directory"
	      if file =~ /bags$/
          # debug "Bags dir found"
	        bagDirContents = Dir["#{file}/*"]
          # debug bagDirContents
          # @bagControllers ||= {}
          #           @bagWins ||= {}
          bagDirContents.each do | bagFile |
            debug bagFile
            bagName = bagFile.split("/")[-1].gsub(".yaml", "")
            # debug "Bag name: '#{bagName}', loading ..."
            bagContents = YAML::load_file(bagFile)
            # debug bagContents
            # debug "... loaded bag."
            
            # winHeight = 19 + 21 * (bagContents.size + 1)
            # bagWin = window :title => "Bag #{bagName}, #{bagContents.size} pieces", :width => 340, :height => winHeight do
            #   #
            # end
            # @bagWins[bagName] = bagWin
            # bagWin.close()
            # tehBag = Bag.new(bagWin, self, "#{bagName}")
            # tehBag.components = bagContents
            teh_bagnowin = BagNoWin.new("#{bagName}")
            teh_bagnowin.components = bagContents
            @bag_contents[bagName] = teh_bagnowin.components.dup()
            @bagnowin_model[bagName] = teh_bagnowin
            # @bagControllers[bagName] = tehBag
            #tehBag.update()
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
            debug "@selectedPosition put in BoardSide object"
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
      # @stageWindows = []
      @stageComponents = {}

      @numberOfStages = @stageDirContents.size
    
      tmpStageComponents = {}
      
      @stage_name_to_positions = tmpStageComponents
    
      @numberOfStages.times do | i |
        stagename = @stageDirContents[i].split("/")[-1].gsub(".txt","")
        # tmpWin = window :title => "Stage #{stagename}", :width => 250, :height => 60 do
          # ;
        # end
        # @stageWindows << tmpWin
        # @stages << BuildStage.new(tmpWin, self)
        @stagenowin_model[stagename] = BuildStageNoWin.new()
        @stagenowin_model[stagename].stagename = stagename
        # debug @stages[0]
        # @stageComponents[@stages[i].stagename] = @stages[i].positions
      
        # @stages[i].stagename = stagename
        tmpStageComponents[stagename] = File.read(@stageDirContents[i]).strip().split(" ")
        # tmpStageComponents[stagename] = tmpStageComponents[i]
        # debug tmpStageComponents[i]
      end

      # debug "Developer note: remember to sync the stageComponents lookup to the board positions post-load"
      # debug tmpStageComponents
      #   debug tmpStageComponents[0]
      #   debug tmpStageComponents[0].class()
      tmpStageComponents.each do | stagename, stage |
        # debug "Populating stage '#{stagename}'"
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
            # debug "Putting pos '#{pos}' into @stages[#{stagename}]"
            if (pos)
              # debug "'stagename': #{stagename}"
              @stagenowin_model[stagename].positions << pos
              # @stages[stagename].positions << pos
            end
          end
        end
        # debug "Updating stage nr. #{stagename}, name '#{@stages[stagename].stagename}'"
        # @stagesnowin_model[stagename].update()
        # @stages[stagename].update()
      end
      # @stages[0].update
    else
      debug "Stage dir contents are none ... hmm"
    end
    # tmpWin = window :title => "Stage #{i + 1}", :width => 250, :height => 60 do
    @bags_window_window = window :title => "Bags" do end
    # @bagnowin_model = {}
    @bags_window = BagsWindow.new(@bags_window_window, self, @bag_contents, @bagnowin_model)
    @bags_window.update()
    
    @stages_window_window = window :title => "Build Stages" do
      # dur
    end
    @stages_window = StagesWindow.new(@stages_window_window, self, @stage_name_to_positions, @stagenowin_model)
    @stages_window.update()
    
    go()
  end
  
  def go()
    @datapack_button_flow.clear()

  	# loadDatapack("amp32")
    # loadDatapack("amp4")
    # loadDatapack("amp15-ps")
    # loadDatapack(ask_open_folder)

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
    end
    
    @loadButton = button "Load Board Posn's" do
      debug "Load button triggered - no functionality!"
    end

    # autoclick
    begin
    end

    # @selectedPosition = nil # Position.new() #TODO: fix / use / toss
  end
end

Shoes.app(:width => 480, :height => 100) do
	Shoes.show_log()
	
	findDatapacks()
	
	@datapack_buttons ||= []
	@datapack_buttons.clear()
	@datapack_button_flow = flow do
	  @datapacks.each do | datapack_dir |
  	  btn_str = "Open #{datapack_dir.gsub(".helperdeck", "").split("/")[-1].upcase()}"
  	  teh_button = button :text => btn_str
  	  teh_button.click do
  	    loadDatapack(datapack_dir)
      end
  	  @datapack_buttons << teh_button
    end
    welcomeButton = button :text => "Open a .helperdeck datapack directory ..."
  	welcomeButton.click do 
  		loadDatapack(ask_open_folder)
  	end
  end
end


