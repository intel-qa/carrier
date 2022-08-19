module IntelQA::Carrier
  struct RGBA
    # Create a `RGBA` struct from a hex color string.
    #
    # Formats:
    # * "#rgb"
    # * "#rrggbb"
    # * "#argb"
    # * "#aarrggbb"
    def self.from_hex(hex : String)
      raise "Invalid hex color: #{hex}" if hex.size == 0 || hex[0] != '#'

      case hex.size
      when 4
        r = hex[1].to_i(16)
        g = hex[2].to_i(16)
        b = hex[3].to_i(16)
        from_rgb_n(r, g, b, 4)
      when 5
        a = hex[1].to_i(16)
        r = hex[2].to_i(16)
        g = hex[3].to_i(16)
        b = hex[4].to_i(16)
        from_rgba_n(r, g, b, a, 4)
      when 7
        r = hex[1,2].to_i(16)
        g = hex[3,2].to_i(16)
        b = hex[5,2].to_i(16)
        from_rgb_n(r, g, b, 8)
      when 9
        a = hex[1,2].to_i(16)
        r = hex[3,2].to_i(16)
        g = hex[5,2].to_i(16)
        b = hex[7,2].to_i(16)
        from_rgba_n(r, g, b, a, 8)
      else
        raise "Invalid hex color: #{hex}"
      end
    end
  end

  struct RGB
    # Create a `RGBA` struct from a hex color string.
    #
    # Formats:
    # * "#rgb"
    # * "#rrggbb"
    # * "#argb"
    # * "#aarrggbb"
    def self.from_hex(hex : String)
      raise "Invalid hex color: #{hex}" if hex.size == 0 || hex[0] != '#'

      case hex.size
      when 4, 5
        r = hex[1].to_i(16)
        g = hex[2].to_i(16)
        b = hex[3].to_i(16)
        from_rgb_n(r, g, b, 4)
      when 7, 9
        r = hex[1,2].to_i(16)
        g = hex[3,2].to_i(16)
        b = hex[5,2].to_i(16)
        from_rgb_n(r, g, b, 8)
      else
        raise "Invalid hex color: #{hex}"
      end
    end
  end

  struct GA
    # Create a `RGBA` struct from a hex color string.
    #
    # Formats:
    # * "#rgb"
    # * "#rrggbb"
    # * "#argb"
    # * "#aarrggbb"
    def self.from_hex(hex : String)
      raise "Invalid hex color: #{hex}" if hex.size == 0 || hex[0] != '#'

      case hex.size
      when 4
        raise "Invalid hex greyscale color" if hex[1..3].split("").uniq.size != 1
        g = hex[1].to_i(16)
        from_g_n(g, 4)
      when 5
        raise "Invalid hex greyscale color" if hex[2..4].split("").uniq.size != 1
        a = hex[1].to_i(16)
        g = hex[2].to_i(16)
        from_ga_n(g, a, 4)
      when 7
        raise "Invalid hex greyscale color" if [hex[1..2], hex[3..4], hex[4..5]].uniq.size != 1
        g = hex[1,2].to_i(16)
        from_g_n(g, 8)
      when 9
        raise "Invalid hex greyscale color" if [hex[3..4], hex[4..5], hex[7..8]].uniq.size != 1
        a = hex[1,2].to_i(16)
        g = hex[3,2].to_i(16)
        from_ga_n(g, a, 8)
      else
        raise "Invalid hex color: #{hex}"
      end
    end
  end

  struct G
    # Create a `RGBA` struct from a hex color string.
    #
    # Formats:
    # * "#rgb"
    # * "#rrggbb"
    # * "#argb"
    # * "#aarrggbb"
    def self.from_hex(hex : String)
      raise "Invalid hex color: #{hex}" if hex.size == 0 || hex[0] != '#'

      case hex.size
      when 4
        raise "Invalid hex greyscale color" if hex[1..3].split("").uniq.size != 1
        g = hex[1].to_i(16)
        from_g_n(g, 4)
      when 5
        raise "Invalid hex greyscale color" if hex[2..4].split("").uniq.size != 1
        g = hex[2].to_i(16)
        from_g_n(g, 4)
      when 7
        raise "Invalid hex greyscale color" if [hex[1..2], hex[3..4], hex[5..6]].uniq.size != 1
        g = hex[1,2].to_i(16)
        from_g_n(g, 8)
      when 9
        raise "Invalid hex greyscale color" if [hex[3..4], hex[4..5], hex[7..8]].uniq.size != 1
        g = hex[3,2].to_i(16)
        from_g_n(g, 8)
      else
        raise "Invalid hex color: #{hex}"
      end
    end
  end
end
