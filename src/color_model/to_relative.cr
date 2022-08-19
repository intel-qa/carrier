module IntelQA::Carrier
  struct RGBA
    # Create a RGBA struct from
    # float values `r`, `g`, `b`, `a`
    # ranging from `0.0` to `1.0`.
    #
    # `{1.0, 0.0, 0.0, 0.5}` would be the color red
    # with an opacity of 50%.
    def self.from_relative(r, g, b, a)
      RGBA.new(
        (r * UInt16::MAX).to_u16,
        (g * UInt16::MAX).to_u16,
        (b * UInt16::MAX).to_u16,
        (a * UInt16::MAX).to_u16
      )
    end

    # Create a tuple `{r, g, b, a}`,
    # each ranging from `0.0` to `1.0`
    # from this color.
    def to_relative
      {
        r.to_f / UInt16::MAX,
        g.to_f / UInt16::MAX,
        b.to_f / UInt16::MAX,
        a.to_f / UInt16::MAX,
      }
    end
  end

  struct RGB
    # Create a RGBA struct from
    # float values `r`, `g`, `b`, `a`
    # ranging from `0.0` to `1.0`.
    #
    # `{1.0, 0.0, 0.0, 0.5}` would be the color red
    # with an opacity of 50%.
    def self.from_relative(r, g, b)
      RGBA.new(
        (r * UInt16::MAX).to_u16,
        (g * UInt16::MAX).to_u16,
        (b * UInt16::MAX).to_u16
      )
    end

    # Create a tuple `{r, g, b, a}`,
    # each ranging from `0.0` to `1.0`
    # from this color.
    def to_relative
      {
        r.to_f / UInt16::MAX,
        g.to_f / UInt16::MAX,
        b.to_f / UInt16::MAX
      }
    end
  end

  struct GA
    # Create a RGBA struct from
    # float values `r`, `g`, `b`, `a`
    # ranging from `0.0` to `1.0`.
    #
    # `{1.0, 0.0, 0.0, 0.5}` would be the color red
    # with an opacity of 50%.
    def self.from_relative(r, g, b, a)
      GA.new(
        (g * UInt16::MAX).to_u16,
        (a * UInt16::MAX).to_u16
      )
    end

    # Create a tuple `{r, g, b, a}`,
    # each ranging from `0.0` to `1.0`
    # from this color.
    def to_relative
      {
        g.to_f / UInt16::MAX,
        a.to_f / UInt16::MAX
      }
    end
  end


  struct G
    # Create a RGBA struct from
    # float values `r`, `g`, `b`, `a`
    # ranging from `0.0` to `1.0`.
    #
    # `{1.0, 0.0, 0.0, 0.5}` would be the color red
    # with an opacity of 50%.
    def self.from_relative(r, g, b)
      G.new(
        (g * UInt16::MAX).to_u16
      )
    end

    # Create a tuple `{r, g, b, a}`,
    # each ranging from `0.0` to `1.0`
    # from this color.
    def to_relative
      {
        g.to_f / UInt16::MAX
      }
    end
  end

end
