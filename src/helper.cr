module Image::Carrier
  module Helper
    def self.max_graylevel(resolution = 16)
      2 ** resolution - 1
    end

    # Helper method,
    # scale a value `input`
    # from `from` bits resolution
    # to 16 bits.
    def self.scale_resolution(value, initial)
      return value.to_u16 if initial == 16
      (value.to_f / max_graylevel(initial) * max_graylevel).round.to_u16
    end

    # Helper method,
    # scale a value `input`
    # from `from` bits resolution
    # to `to` bits resolution.
    def self.scale_resolution(value, initial, final)
      (value.to_f / max_graylevel(initial) * max_graylevel(final)).round
    end
  end
end
