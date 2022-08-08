module Image::Carrier

  PIXEL_TYPES = {
    "G" => :grayscale,
    "GA" => :grayscale_alpha,
    "RGB" => :rgb,
    "RGBA" => :rgb_alpha,
  }

  # A grid is 2D array of `T` pixels
  #
  # To create a grid of size `400` x `200`
  #
  # ```
  # grid = ImageCarrier::Grid.new(400, 200)
  # ```
  #
  # The default background color is transparent,
  # but it can be passed in as a parameter or as a block
  # that returns the color value for each `{x, y}` pair.
  #
  # ```
  # canvas2 = ImageCarrier::Grid.new(400, 200, RGBA::WHITE)
  # ```
  #
  # ```
  # canvas3 = ImageCarrier::Grid.new(256, 256) do |x, y|
  #   RGBA.from_rgb_n(x, y, 255, 8)
  # end
  # ```
  #
  # Because of the way pixels are stored in a `Slice`,
  # `Grid`s are limited to `Int32::MAX = 2147483647` pixels in total,
  # e.g. a maximal size of 46340x46340 for a square image.
  class Grid(T)
    getter width : Int32
    getter height : Int32
    getter pixels : Slice(T)

    def initialize(@width = 0, @height = 0, color = T.null)
      size = @width.to_i64 * @height
      raise "The maximum size of a grid is #{Int32::MAX} total pixels" if size > Int32::MAX

      @pixels = Slice.new size.to_i32, color
    end

    def initialize(@width, @height, &block)
      size = @width.to_i64 * @height
      raise "The maximum size of a grid is #{Int32::MAX} total pixels" if size > Int32::MAX

      @pixels = Slice.new size.to_i32, T.new

      (0...@height).each do |y|
        (0...@width).each do |x|
          color = yield({x, y})
          set x, y, color
        end
      end
    end

    # Get the value of pixel `(x, y)`
    # without checking if `(x, y)` is a valid position.
    def get(x, y)
      @pixels[x + @width * y]
    end

    # Set the value of pixel `(x, y)` to `color`
    # without checking if `(x, y)` is a valid position.
    def set(x, y, color)
      @pixels[x + @width * y] = color
    end

    # Short form for `get`
    def [](x, y)
      get x, y
    end

    # Short form for `set`
    def []=(x, y, color)
      set x, y, color
    end

    # Same as `get`, but if `x` ore `y` are outside of the grid,
    # wrap them over at the edges.
    # E.g. `wrapping_get(300, 250)` on a 200x200 grid
    # returns the pixel at `(100, 50)`.
    def wrapping_get(x : Int32, y : Int32) : T
      self[x % @width, y % @height]
    end

    # Same as `set`, but wrapping along the grid edges.
    # See `wrapping_get` for an example.
    def wrapping_set(x : Int32, y : Int32, color : T)
      self[x % @width, y % @height] = color
    end

    # Same as `get`,
    # but returns `nil` if `(x, y)` are outside of the grid
    def safe_get(x : Int32, y : Int32) : T | Nil
      includes_location?(x, y) ? self[x, y] : nil
    end

    # Same as `set`, but only sets the pixel,
    # if it is part of the grid.
    # Returns `true` if the pixel was set successfully,
    # `false` if it was outside of the grid.
    def safe_set(x : Int32, y : Int32, color : T) : Bool
      if includes_location?(x, y)
        self[x, y] = color
        true
      else
        false
      end
    end

    # Check if pixel `(x, y)` is part of this grid.
    def includes_location?(x, y)
      0 <= x && x < @width && 0 <= y && y < @height
    end

    # Iterate over each row of the grid
    # (a `Slice(RGBA)` of size `@width`).
    # The main usecase for this is
    # writing code that encodes images
    # in some file format.
    def each_row(&block)
      @height.times do |n|
        yield @pixels[n * @width, @width]
      end
    end

    # Same as `map!`, but instead of mutating the current grid,
    # a new one is created and returned
    def map(&block)
      grid = Grid(T).new(@width, @height)
      (0...@height).each do |y|
        (0...@width).each do |x|
          grid[x, y] = yield self[x, y], x, y
        end
      end
      grid
    end

    # Modify pixels by
    # applying a function `(color, x, y) -> new_color`
    # to each pixel of the current grid,
    # e.g. to invert colors
    def map!(&block)
      (0...@height).each do |y|
        (0...@width).each do |x|
          self[x, y] = yield self[x, y], x, y
        end
      end
      self
    end

    # Same as `map` but passes along a fourth parameter
    # with the index in the `pixels` slice
    def map_with_index(&block)
      grid = Grid(T).new(@width, @height)
      (0...@height).each do |y|
        offset = @width * y
        (0...@width).each do |x|
          grid[x, y] = yield self[x, y], x, y, offset + x
        end
      end
      grid
    end

    # Same as `map!` but passes along a fourth parameter
    # with the index in the `pixels` slice
    def map_with_index!(&block :  T, Int32, Int32, Int32 -> T)
      (0...@height).each do |y|
        offset = @width * y
        (0...@width).each do |x|
          self[x, y] = yield self[x, y], x, y, offset + x
        end
      end
    end

    # Two canvases are considered equal
    # if they are of equal size
    # and all their pixels are equal
    def ==(other)
      self.class == other.class &&
        @width == other.width &&
        @height == other.height &&
        @pixels == other.pixels
    end

    # Paste the contents of a second `Grid`
    # into this one,
    # starting at position `(x, y)`.
    # The pixels are combined using the `RGBA#over` function.
    def paste(grid : Grid(T), x, y)
      (0...grid.width).each do |cx|
        (0...grid.height).each do |cy|
          current = safe_get(x + cx, y + cy)
          unless current.nil?
            self[x + cx, y + cy] = grid[cx, cy].over(current)
          end
        end
      end
    end

    def pixel_type
      PIXEL_TYPES[T.to_s.split("::").last].tap do |t|
        raise "Not a pixel grid" if t.nil?
      end
    end

    def each(type = :grid, index = Int32::MIN)
      case type
      when :row
        (0...@width).each do |x|
          yield self[x, index], x
        end
      when :column
        (0...@height).each do |y|
          yield self[index, y], y
        end
      else
        (0...@height).each do |y|
          (0...@width).each do |x|
            yield self[x, y], x, y
          end
        end
      end
    end

    def reduce(accumulator)
      (0...@height).each do |y|
        (0...@width).each do |x|
          accumulator = yield accumulator, self[x, y]
        end
      end
      accumulator
    end

    def to_s(io : IO)
      io << "Grid{"
      each do |v, x, y|
        io << '\t' << [x, y]
      end
      io << "}"
    end
  end
end
