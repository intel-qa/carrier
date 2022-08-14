module Image::Carrier
  module Helper
    def self.max_graylevel(resolution = 16)
      2 ** resolution - 1
    end

    # Helper method,
    # scale a of `input`
    # from `from` bits resolution
    # to 16 bits.
    def self.scale_resolution(of, from)
      return of.to_u16 if from == 16
      (of.to_f / max_graylevel(from) * max_graylevel).round.to_u16
    end

    # Helper method,
    # scale a of `input`
    # from `from` bits resolution
    # to `to` bits resolution.
    def self.scale_resolution(of, from, to)
      (of.to_f / max_graylevel(from) * max_graylevel(to)).round
    end
  end
end
