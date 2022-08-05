module Image::Carrier
  # A `RGBA` is made up of four components:
  # `red`, `green`, `blue` and `alpha`,
  # each with a resolution of 16 bit.
  #
  # All 148 [Named CSS Colors](https://www.quackit.com/css/css_color_codes.cfm)
  # are available as constants.
  struct RGBA
    NULL = RGBA.new

    getter r : UInt16
    getter g : UInt16
    getter b : UInt16
    getter a : UInt16

    def initialize
      @r = @g = @b = @a = 0_u16
    end

    # Create a RGBA value
    # from 16bit (`UInt16`)
    # values for red, green, blue and
    # optionally alpha.
    # Alpha defaults to 100% opacity.
    def initialize(@r, @g, @b, @a = UInt16::MAX)
    end

    # Create a RGBA value
    # from 16bit (`UInt16`)
    # values for grayscale (gray = red = green = blue)
    # and optionally alpha.
    # Alpha defaults to 100% opacity.
    def initialize(gray : UInt16, @a = UInt16::MAX)
      @r = @g = @b = gray
    end

    def red
      @r
    end

    def green
      @g
    end

    def blue
      @b
    end

    def alpha
      @a
    end
  end

  # A `RGBA` is made up of four components:
  # `red`, `green`, `blue` and `alpha`,
  # each with a resolution of 16 bit.
  #
  # All 148 [Named CSS Colors](https://www.quackit.com/css/css_color_codes.cfm)
  # are available as constants.
  struct RGB
    NULL = RGB.new

    getter r : UInt16
    getter g : UInt16
    getter b : UInt16

    def initialize
      @r = @g = @b = 0_u16
    end

    # Create a RGBA value
    # from 16bit (`UInt16`)
    # values for red, green, blue and
    # optionally alpha.
    # Alpha defaults to 100% opacity.
    def initialize(@r, @g, @b)
    end

    # Create a RGBA value
    # from 16bit (`UInt16`)
    # values for grayscale (gray = red = green = blue)
    # and optionally alpha.
    # Alpha defaults to 100% opacity.
    def initialize(gray : UInt16)
      @r = @g = @b = gray
    end

    def red
      @r
    end

    def green
      @g
    end

    def blue
      @b
    end
  end

  # A `RGBA` is made up of four components:
  # `red`, `green`, `blue` and `alpha`,
  # each with a resolution of 16 bit.
  #
  # All 148 [Named CSS Colors](https://www.quackit.com/css/css_color_codes.cfm)
  # are available as constants.
  struct GA
    NULL = GA.new

    getter g : UInt16
    getter a : UInt16

    def initialize
      @g = @a = 0_u16
    end

    # Create a RGBA value
    # from 16bit (`UInt16`)
    # values for grayscale (gray = red = green = blue)
    # and optionally alpha.
    # Alpha defaults to 100% opacity.
    def initialize(@g : UInt16, @a = UInt16::MAX)
    end

    def grey
      @g
    end

    def alpha
      @a
    end
  end

  # A `RGBA` is made up of four components:
  # `red`, `green`, `blue` and `alpha`,
  # each with a resolution of 16 bit.
  #
  # All 148 [Named CSS Colors](https://www.quackit.com/css/css_color_codes.cfm)
  # are available as constants.
  struct G
    NULL = G.new

    getter g : UInt16

    def initialize
      @g = 0_u16
    end

    # Create a RGBA value
    # from 16bit (`UInt16`)
    # values for grayscale (gray = red = green = blue)
    # and optionally alpha.
    # Alpha defaults to 100% opacity.
    def initialize(@g : UInt16)
    end

    def grey
      @g
    end
  end
end
