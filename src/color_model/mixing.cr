module IntelQA::Carrier
  struct RGBA
    # Linear interpolation
    # (mixing) of two colors.
    # `t` ranges from `0.0` to `1.0`.
    #
    # ```
    # a.mix(b, 0.0) == a
    # a.mix(b, 1.0) == b
    # ```
    def mix(other, t)
      RGBA.new(
        (@r * (1.0 - t) + other.r * t).to_u16,
        (@g * (1.0 - t) + other.g * t).to_u16,
        (@b * (1.0 - t) + other.b * t).to_u16,
        (@a * (1.0 - t) + other.a * t).to_u16,
      )
    end

    # Mix two colors by multiplying their values
    def multiply(other : RGBA) : RGBA
      r0, g0, b0, a0 = self.to_relative
      r1, g1, b1, a1 = other.to_relative

      RGBA.from_relative(
        r0 * r1,
        g0 * g1,
        b0 * b1,
        a0 * a1
      )
    end

    # Mix two colors by using
    # [Alhpa Compositing](https://en.wikipedia.org/wiki/Alpha_compositing)
    def over(other : RGBA) : RGBA
      if self.a == UInt16::MAX
        self
      elsif self.a == 0
        other
      else
        alpha_a = self.a.to_f / UInt16::MAX
        alpha_b = other.a.to_f / UInt16::MAX

        # Some precalculated factors
        pre_1 = alpha_b * (1 - alpha_a)
        alpha_0 = alpha_a + pre_1

        new_r = ((self.r * alpha_a) + (other.r * pre_1)) / alpha_0
        new_g = ((self.g * alpha_a) + (other.g * pre_1)) / alpha_0
        new_b = ((self.b * alpha_a) + (other.b * pre_1)) / alpha_0
        new_a = alpha_0 * UInt16::MAX

        RGBA.new(new_r.to_u16, new_g.to_u16, new_b.to_u16, new_a.to_u16)
      end
    end

  end

  struct RGB
    # Linear interpolation
    # (mixing) of two colors.
    # `t` ranges from `0.0` to `1.0`.
    #
    # ```
    # a.mix(b, 0.0) == a
    # a.mix(b, 1.0) == b
    # ```
    def mix(other, t)
      RGB.new(
        (@r * (1.0 - t) + other.r * t).to_u16,
        (@g * (1.0 - t) + other.g * t).to_u16,
        (@b * (1.0 - t) + other.b * t).to_u16
      )
    end

    # Mix two colors by multiplying their values
    def multiply(other : RGB) : RGB
      r0, g0, b0, a0 = self.to_relative
      r1, g1, b1, a1 = other.to_relative

      RGB.from_relative(
        r0 * r1,
        g0 * g1,
        b0 * b1
      )
    end

    # Mix two colors by using
    # [Alhpa Compositing](https://en.wikipedia.org/wiki/Alpha_compositing)
    def over(other : RGB) : RGB
      self
    end

  end

  struct GA
    # Linear interpolation
    # (mixing) of two colors.
    # `t` ranges from `0.0` to `1.0`.
    #
    # ```
    # a.mix(b, 0.0) == a
    # a.mix(b, 1.0) == b
    # ```
    def mix(other, t)
      GA.new(
        (@g * (1.0 - t) + other.g * t).to_u16,
        (@a * (1.0 - t) + other.a * t).to_u16
      )
    end

    # Mix two colors by multiplying their values
    def multiply(other : GA) : GA
      g0, a0 = self.to_relative
      g1, a1 = other.to_relative

      RGBA.from_relative(
        r0 * r1,
        g0 * g1,
        b0 * b1,
        a0 * a1
      )
    end

    # Mix two colors by using
    # [Alhpa Compositing](https://en.wikipedia.org/wiki/Alpha_compositing)
    def over(other : GA) : GA
      if self.a == UInt16::MAX
        self
      elsif self.a == 0
        other
      else
        alpha_a = self.a.to_f / UInt16::MAX
        alpha_b = other.a.to_f / UInt16::MAX

        # Some precalculated factors
        pre_1 = alpha_b * (1 - alpha_a)
        alpha_0 = alpha_a + pre_1

        new_g = ((self.g * alpha_a) + (other.g * pre_1)) / alpha_0
        new_a = alpha_0 * UInt16::MAX

        GA.new(new_g.to_u16, new_a.to_u16)
      end
    end

  end

  struct G
    # Linear interpolation
    # (mixing) of two colors.
    # `t` ranges from `0.0` to `1.0`.
    #
    # ```
    # a.mix(b, 0.0) == a
    # a.mix(b, 1.0) == b
    # ```
    def mix(other, t)
      G.new(
        (@g * (1.0 - t) + other.g * t).to_u16
      )
    end

    # Mix two colors by multiplying their values
    def multiply(other : G) : G
      g0 = self.to_relative
      g1 = other.to_relative

      G.from_relative(
        g0 * g1
      )
    end

    # Mix two colors by using
    # [Alhpa Compositing](https://en.wikipedia.org/wiki/Alpha_compositing)
    def over(other : G) : G
      self
    end

  end
end
