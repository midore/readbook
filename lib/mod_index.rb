module ReadBook

  module FileIndex

    def txtpath(dir, ean)
      indexfiles(dir)[ean.to_i]
    end

    private

    def to_h
      files = Hash.new
      Proc.new{|dir,ext|
        Dir.foreach(dir){|x|
          n = File.basename(x).to_i
          fullpath = File.join(dir, x)
          files[n] = fullpath if /^[0-9]{11}..?\-(.*?).txt$/ =~ x
        }
        files
      }
    end

    def indexfiles(dir)
      return nil unless FileTest.exist?(dir)
      t = to_h
      t.call(dir, ".txt")
    end

  end

end
