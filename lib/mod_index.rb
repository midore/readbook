module ReadBook

  module FileIndex

    def txtpath(dir, ean)
      indexfiles(dir)[ean.to_i]
    end

    private

    def to_h
      files = Hash.new
      Proc.new do |dir,ext|
        Find.find(dir){|path|
          Find.prune if path =~ /trash/
          if FileTest.file?(path) and File.extname(path) == ext
            display_name = File.basename(path).gsub(File.extname(path), '')
            display_name.to_i
            files[display_name.to_i] = path
          end
        }
        files
      end
    end

    def indexfiles(dir)
      return nil unless FileTest.exist?(dir)
      t = to_h
      t.call(dir, ".txt")
    end

  end

end