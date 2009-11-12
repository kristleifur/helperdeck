class ExplodingBox
  attr_accessor :x, :y, :width, :height
  
  def initialize(x, y, width, height)
    @@maxPixelGrowth = 35.0
    @@stepsToTake = 15.0
    @currentStep = 1
    @x = x
    @y = y
    @width = width
    @height = height
    @lastDisplacement = 0.0
  end
  
  def step()
    if @currentStep < @@stepsToTake
      # increment = (@@maxPixelGrowth / @@stepsToTake) / 2.0

      # squaredDisplacement = @@maxPixelGrowth * ((@@stepsToTake * @@stepsToTake) / ((@@stepsToTake - @currentStep) * (@@stepsToTake - @currentStep))) / (@@stepsToTake * @@stepsToTake)       
      # squaredDisplacement = @@maxPixelGrowth * ((@@stepsToTake * @@stepsToTake) / (@currentStep * @currentStep)) / (@@stepsToTake * @@stepsToTake) 
      # squaredDisplacement = @@maxPixelGrowth - @@maxPixelGrowth * ((@@stepsToTake * @@stepsToTake) / (@currentStep * @currentStep)) / (@@stepsToTake * @@stepsToTake) 
      squaredDisplacement = @@maxPixelGrowth - @@maxPixelGrowth * ((@@stepsToTake) / (@currentStep)) / (@@stepsToTake) 
      
      
      # squaredDisplacement = @@maxPixelGrowth * (((@@stepsToTake - @currentStep) * (@@stepsToTake - @currentStep)))
      
      @x = @x + @lastDisplacement / 2.0 - squaredDisplacement / 2.0
      @y = @y + @lastDisplacement / 2.0 - squaredDisplacement / 2.0
      @width = @width - @lastDisplacement + squaredDisplacement
      @height = @height - @lastDisplacement + squaredDisplacement
      # @y -= incremenst
      # @width += increment * 2.0
      # @height += increment * 2.0
      @lastDisplacement = squaredDisplacement
      @currentStep += 1
    end
  end
  
  def done?()
    return (@currentStep >= @@stepsToTake)
  end
end
