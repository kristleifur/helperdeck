class Position
  attr_accessor :x, :y, :width, :height, :name, :components
  def initialize(x = 0, y = 0, width = 0, height = 0)
    @x = x;
    @y = y;
    @width = width;
    @height = height;
    @name = ""
    @components = []
  end
  
  def left=(left)
    @x = left
  end
  
  def top=(top)
    @y = top
  end
  
  def fix()
    if (@width < 0)
              @x += @width
      @width = -@width
    end
    if (@height < 0)
      @y += @height
      @height = -@height
    end
  end
  
  def left(left = nil)
    if (left)
      @x = left
    end
    return @x
  end
  
  def right(right = nil)
    if (right)
      @width = right - x
    end
    fix()
    return @x + @width
  end
  
  def top(top = nil)
    if (top)
      @y = top
    end
    return @y
  end
  
  def bottom(bottom = nil)
    if (bottom)
      @height = bottom - y
    end
    fix()
    return @y + @height
  end
end

