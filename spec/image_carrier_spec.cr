require "./spec_helper"

include IntelQA::Carrier

describe IntelQA::Carrier do
  describe "Grid(RGBA)" do
    describe ".new" do
      it "throws an error if the size is to big" do
        size = 2**30
        expect_raises(Exception) do
          grid = Grid(RGBA).new(size, size)
        end
      end

      it "uses default initial value for color if none provided" do
        size = 3
        grid = Grid(RGBA).new(size, size)
        (0...size).each do |x|
          (0...size).each do |y|
            grid.get(x, y).should eq RGBA.new(0_u16, 0_u16, 0_u16, UInt16::MAX)
          end
        end
      end
    end

    describe "#get" do
      it "gets the color value of a particular pixel location" do
        size = 3
        canvas1 = Grid(RGBA).new(size, size)
        canvas2 = Grid(RGBA).new(size, size) {RGBA.new(0_u16, 0_u16, 0_u16)}

        (0...size).each do |x|
          (0...size).each do |y|
            canvas1.get(x, y).should eq canvas2.get(x, y)
          end
        end
      end
    end

    describe "#set" do
      it "sets a pixel to specified color" do
        size = 3
        canvas1 = Grid(RGBA).new(size, size)

        (0...size).each do |x|
          (0...size).each do |y|
            canvas1.set(x, y, RGBA::ORANGE)
          end
        end

        canvas2 = Grid(RGBA).new(size, size) {RGBA::ORANGE}

        (0...size).each do |x|
          (0...size).each do |y|
            canvas1.get(x, y).should eq canvas2.get(x, y)
          end
        end
      end
    end

    describe "#each_row" do
      it "iterates over each row of the grid" do
        size = 3
        grid = Grid(RGBA).new(size, size)
        grid.each_row {|row| row[1] = RGBA::GREEN; row[2] = RGBA::BLUE }
        grid[0, 0].should eq(RGBA.new)
        grid[1, 1].should eq(RGBA::GREEN)
        grid[2, 2].should eq(RGBA::BLUE)
      end
    end

    describe "#includes_location?" do
      it "checks if a pixel is out of bounds" do
        size = 3
        grid = Grid(RGBA).new(size, size)

        grid.includes_location?(2, 2).should be_true
        grid.includes_location?(3, 3).should be_false
      end
    end

    describe "#map" do
      it "maps each pixel color to a diff color" do
        size = 3
        grid = Grid(RGBA).new(size, size)
        res = grid.map_with_index {|p, x, y| (x+y).even? ? RGBA::BLACK : RGBA::WHITE }
        grid[0, 0].should eq(RGBA.new)
        grid[1, 0].should eq(RGBA.new)
        grid[0, 1].should eq(RGBA.new)
        grid[2, 2].should eq(RGBA.new)
        res[0, 0].should eq(RGBA::BLACK)
        res[1, 0].should eq(RGBA::WHITE)
        res[0, 1].should eq(RGBA::WHITE)
        res[2, 2].should eq(RGBA::BLACK)
      end
    end

    describe "#map!" do
      it "changes each pixel color to a diff color" do
        size = 3
        grid = Grid(RGBA).new(size, size)
        grid.map! {|p, x, y| (x+y).even? ? RGBA::BLACK : RGBA::WHITE }
        grid[0, 0].should eq(RGBA::BLACK)
        grid[1, 0].should eq(RGBA::WHITE)
        grid[0, 1].should eq(RGBA::WHITE)
        grid[2, 2].should eq(RGBA::BLACK)
      end
    end

    describe "#map_with_index" do
      it "maps each pixel color and index to a diff color" do
        size = 3
        grid = Grid(RGBA).new(size, size, RGBA::RED)
        res = grid.map_with_index {|p, x, y, i| i.even? ? RGBA::BLACK : RGBA::WHITE }
        grid[0, 0].should eq(RGBA::RED)
        grid[1, 0].should eq(RGBA::RED)
        grid[0, 1].should eq(RGBA::RED)
        res[0, 0].should eq(RGBA::BLACK)
        res[1, 0].should eq(RGBA::WHITE)
        res[0, 1].should eq(RGBA::WHITE)
      end
    end

    describe "#map_with_index!" do
      it "changes each pixel color and index to a diff color" do
        size = 3
        grid = Grid(RGBA).new(size, size, RGBA::RED)
        grid.map_with_index! {|p, x, y, i| i.even? ? RGBA::BLACK : RGBA::WHITE }
        grid[0, 0].should eq(RGBA::BLACK)
        grid[1, 0].should eq(RGBA::WHITE)
        grid[0, 1].should eq(RGBA::WHITE)
      end
    end

    describe "#==" do
      it "checks if 2 canvases are equal" do
        side = 3
        other_side = 4
        canvas1 = Grid(RGBA).new(side, side)
        canvas2 = Grid(RGBA).new(side, side, RGBA.new(0_u16, 0_u16, 0_u16))
        canvas3 = Grid(RGBA).new(side, side, RGBA::WHITE)
        canvas4 = Grid(RGBA).new(side, other_side, RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))
        canvas5 = Grid(RGBA).new(other_side, side, RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))

        (canvas1 == canvas3).should be_false
        (canvas1 == canvas4).should be_false
        (canvas1 == canvas5).should be_false
        (canvas1 == canvas2).should be_true
      end
    end

    describe "#paste" do
      it "pastes the contents of another grid into this grid starting at x, y" do
        size1 = 7
        size2 = 3
        canvas1 = Grid(RGBA).new(size1, size1)
        canvas2 = Grid(RGBA).new(size2, size2, RGBA::WHITE)

        canvas1.paste(canvas2, 2, 2)

        canvas1[0, 0].should eq(RGBA.new)
        canvas1[1, 0].should eq(RGBA.new)
        canvas1[0, 1].should eq(RGBA.new)
        canvas1[2, 2].should eq(RGBA::WHITE)
        canvas1[3, 4].should eq(RGBA::WHITE)
        canvas1[3, 2].should eq(RGBA::WHITE)
        canvas1[6, 6].should eq(RGBA.new)
        canvas1[6, 5].should eq(RGBA.new)
        canvas1[5, 1].should eq(RGBA.new)

        (0...size2).each do |x|
          (0...size2).each do |y|
            canvas2.get(x, y).should eq RGBA::WHITE
          end
        end
      end
    end
  end

  describe "Grid(G)" do
    describe ".new" do
      it "throws an error if the size is to big" do
        size = 2**30
        expect_raises(Exception) do
          grid = Grid(G).new(size, size)
        end
      end

      it "uses default initial value for gray if none provided" do
        size = 3
        grid = Grid(G).new(size, size)
        (0...size).each do |x|
          (0...size).each do |y|
            grid.get(x, y).should eq G.new(0_u16)
          end
        end
      end
    end

    describe "#get" do
      it "gets the color value of a particular pixel location" do
        size = 3
        canvas1 = Grid(G).new(size, size)
        canvas2 = Grid(G).new(size, size) {G.new(0_u16)}

        (0...size).each do |x|
          (0...size).each do |y|
            canvas1.get(x, y).should eq canvas2.get(x, y)
          end
        end
      end
    end

    describe "#set" do
      it "sets a pixel to specified color" do
        size = 3
        canvas1 = Grid(G).new(size, size)

        (0...size).each do |x|
          (0...size).each do |y|
            canvas1.set(x, y, G::SILVER)
          end
        end

        canvas2 = Grid(G).new(size, size) {G::SILVER}

        (0...size).each do |x|
          (0...size).each do |y|
            canvas1.get(x, y).should eq canvas2.get(x, y)
          end
        end
      end
    end

    describe "#each_row" do
      it "iterates over each row of the grid" do
        size = 3
        grid = Grid(G).new(size, size)
        grid.each_row {|row| row[1] = G::WHITE; row[2] = G::BLACK }
        grid[0, 0].should eq(G.new)
        grid[1, 1].should eq(G::WHITE)
        grid[2, 2].should eq(G::BLACK)
      end
    end

    describe "#includes_location?" do
      it "checks if a pixel is out of bounds" do
        size = 3
        grid = Grid(G).new(size, size)

        grid.includes_location?(2, 2).should be_true
        grid.includes_location?(3, 3).should be_false
      end
    end

    describe "#map" do
      it "maps each pixel color to a diff color" do
        size = 3
        grid = Grid(G).new(size, size)
        res = grid.map_with_index {|p, x, y| (x+y).even? ? G::BLACK : G::WHITE }
        grid[0, 0].should eq(G.new)
        grid[1, 0].should eq(G.new)
        grid[0, 1].should eq(G.new)
        grid[2, 2].should eq(G.new)
        res[0, 0].should eq(G::BLACK)
        res[1, 0].should eq(G::WHITE)
        res[0, 1].should eq(G::WHITE)
        res[2, 2].should eq(G::BLACK)
      end
    end

    describe "#map!" do
      it "changes each pixel color to a diff color" do
        size = 3
        grid = Grid(G).new(size, size)
        grid.map! {|p, x, y| (x+y).even? ? G::BLACK : G::WHITE }
        grid[0, 0].should eq(G::BLACK)
        grid[1, 0].should eq(G::WHITE)
        grid[0, 1].should eq(G::WHITE)
        grid[2, 2].should eq(G::BLACK)
      end
    end

    describe "#map_with_index" do
      it "maps each pixel color and index to a diff color" do
        size = 3
        grid = Grid(G).new(size, size, G::GRAY)
        res = grid.map_with_index {|p, x, y, i| i.even? ? G::BLACK : G::WHITE }
        grid[0, 0].should eq(G::GRAY)
        grid[1, 0].should eq(G::GRAY)
        grid[0, 1].should eq(G::GRAY)
        res[0, 0].should eq(G::BLACK)
        res[1, 0].should eq(G::WHITE)
        res[0, 1].should eq(G::WHITE)
      end
    end

    describe "#map_with_index!" do
      it "changes each pixel color and index to a diff color" do
        size = 3
        grid = Grid(G).new(size, size)
        grid.map_with_index! {|p, x, y, i| i.even? ? G::BLACK : G::WHITE }
        grid[0, 0].should eq(G::BLACK)
        grid[1, 0].should eq(G::WHITE)
        grid[0, 1].should eq(G::WHITE)
      end
    end

    describe "#==" do
      it "checks if 2 canvases are equal" do
        side = 3
        other_side = 4
        canvas1 = Grid(G).new(side, side)
        canvas2 = Grid(G).new(side, side, G.new(0_u16))
        canvas3 = Grid(G).new(side, side, G::WHITE)
        canvas4 = Grid(G).new(side, other_side, G.new(0_u16))
        canvas5 = Grid(G).new(other_side, side, G.new(0_u16))
        canvas6 = Grid(RGBA).new(side, side)

        (canvas1 == canvas3).should be_false
        (canvas1 == canvas4).should be_false
        (canvas1 == canvas5).should be_false
        (canvas1 == canvas6).should be_false
        (canvas1 == canvas2).should be_true
      end
    end

    describe "#paste" do
      it "pastes the contents of another grid into this grid starting at x, y" do
        size1 = 7
        size2 = 3
        canvas1 = Grid(G).new(size1, size1)
        canvas2 = Grid(G).new(size2, size2, G::WHITE)

        canvas1.paste(canvas2, 2, 2)

        canvas1[0, 0].should eq(G.new)
        canvas1[1, 0].should eq(G.new)
        canvas1[0, 1].should eq(G.new)
        canvas1[2, 2].should eq(G::WHITE)
        canvas1[3, 4].should eq(G::WHITE)
        canvas1[3, 2].should eq(G::WHITE)
        canvas1[6, 6].should eq(G.new)
        canvas1[6, 5].should eq(G.new)
        canvas1[5, 1].should eq(G.new)

        (0...size2).each do |x|
          (0...size2).each do |y|
            canvas2.get(x, y).should eq G::WHITE
          end
        end
      end
    end
  end

  describe RGBA do
    describe ".new" do
      it "creates a RGBA value from 16bit values for red, green, blue" do
        rgba = RGBA.new(32_u16, 156_u16, 221_u16)
        rgba.r.should eq 32_u16
        rgba.g.should eq 156_u16
        rgba.b.should eq 221_u16
        rgba.a.should eq UInt16::MAX
      end

      # TODO: remove this test. why should we support this constructor?
      # it "creates a RGBA value from 16bit values for grayscale" do
      #   rgba = RGBA.new(156_u16, 156_u16)
      #   rgba.r.should eq 156_u16
      #   rgba.g.should eq 156_u16
      #   rgba.b.should eq 156_u16
      #   rgba.a.should eq 156_u16
      # end

      it "creates a placeholder RGBA value from nothing" do
        rgba = RGBA.new
        rgba.r.should eq 0_u16
        rgba.g.should eq 0_u16
        rgba.b.should eq 0_u16
        rgba.a.should eq UInt16::MAX
      end

    end

    describe ".from_relative" do
      it "is reversible" do
        tuple = {0.2, 0.4, 0.6, 0.8}
        color = RGBA.from_relative(*tuple)
        color.to_relative.should eq(tuple)
      end
    end

    describe ".from_hex" do
      it "handles shorthands" do
        a = RGBA.from_hex("#123")
        b = RGBA.from_hex("#112233")

        a.should eq(b)
      end

      it "handles colors w/ alpha" do
        a = RGBA.from_hex("#F123")
        b = RGBA.from_hex("#FF112233")

        a.should eq(b)
        b.should eq(RGBA.from_hex("#112233"))
      end
    end

    describe ".from_g_n" do
      it "handles 1-bit values" do
        G.from_g_n(0, 1).should eq(G::BLACK)
        G.from_g_n(1, 1).should eq(G::WHITE)
      end

      it "handles 8-bit values" do
        G.from_g_n(0, 8).should eq(G::BLACK)
        G.from_g_n(255, 8).should eq(G::WHITE)

        v = 180
        color = G.from_g_n(v, 8)
        color.g.should eq(UInt16::MAX / 255 * v)
      end
    end

    describe ".from_rgb_n" do
      it "handles 1-bit values" do
        RGBA.from_rgb_n(*{0, 0, 0}, 1).should eq(RGBA::BLACK)
        RGBA.from_rgb_n(*{1, 0, 0}, 1).should eq(RGBA::RED)
        RGBA.from_rgb_n(*{1, 1, 1}, 1).should eq(RGBA::WHITE)
      end

      it "handles 8-bit values" do
        c = RGBA.from_hex("#abcdef")
        vs = c.to_rgb8
        RGBA.from_rgb_n(*vs, 8).should eq(c)
      end
    end
  end

end
