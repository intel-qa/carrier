module Image::Carrier
  struct RGBA
    # Create a `RGBA` struct from n-bit red, green and blue values
    def self.from_rgb_n(r, g, b, n)
      red = Helpers.scale_resolution(r, n)
      green = Helpers.scale_resolution(g, n)
      blue = Helpers.scale_resolution(b, n)
      RGBA.new(red, green, blue, UInt16::MAX)
    end

    # Create a `RGBA` struct from n-bit red, green, blue and alpha values
    def self.from_rgba_n(r, g, b, a, n)
      red = Helpers.scale_resolution(r, n)
      green = Helpers.scale_resolution(g, n)
      blue = Helpers.scale_resolution(b, n)
      alpha = Helpers.scale_resolution(a, n)
      RGBA.new(red, green, blue, alpha)
    end

    # Create a 8-bit `{r, g, b}` tuple,
    # the alpha component is just omitted.
    def to_rgb8
      {
        Helpers.scale_resolution(r, 16, 8).to_u8,
        Helpers.scale_resolution(g, 16, 8).to_u8,
        Helpers.scale_resolution(b, 16, 8).to_u8,
      }
    end
  end

  struct RGB
    # Create a `RGBA` struct from n-bit red, green and blue values
    def self.from_rgb_n(r, g, b, n)
      red = Helpers.scale_resolution(r, n)
      green = Helpers.scale_resolution(g, n)
      blue = Helpers.scale_resolution(b, n)
      RGB.new(red, green, blue)
    end
  end

  struct GA
    # Create a `RGBA` struct from n-bit red, green and blue values
    def self.from_g_n(g, n)
      grey = Helpers.scale_resolution(g, n)
      GA.new(grey, UInt16::MAX)
    end

    # Create a `RGBA` struct from n-bit red, green, blue and alpha values
    def self.from_ga_n(g, a, n)
      grey = Helpers.scale_resolution(g, n)
      alpha = Helpers.scale_resolution(a, n)
      GA.new(grey, alpha)
    end
  end

  struct G
    # Create a `RGBA` struct from n-bit red, green and blue values
    def self.from_g_n(g, n)
      grey = Helpers.scale_resolution(g, n)
      G.new(grey)
    end
  end
end


