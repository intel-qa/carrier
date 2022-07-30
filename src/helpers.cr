module Image::Carrier
  module Helpers
    # Helper method,
    # scale a value `input`
    # from `from` bits resolution
    # to 16 bits.
    def self.scale_resolution(value, initial)
      return value.to_u16 if initial == 16
      (value.to_f / (2 ** initial - 1) * (2 ** 16 - 1)).round.to_u16
    end

    # Helper method,
    # scale a value `input`
    # from `from` bits resolution
    # to `to` bits resolution.
    def self.scale_resolution(value, initial, final)
      (value.to_f / (2 ** initial - 1) * (2 ** final - 1)).round
    end
  end
end
