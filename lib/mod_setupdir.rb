module ReadBook

  module MineSetup

    class MyPath

      include ReadBookConfig

      attr_reader :path

      def initialize
        @path = [dir_base, dir_data, dir_text, dir_subject]
      end

      def check
        self.each{|d| p d}
      end

      def each
        @path.each{|x| yield([exsit?(x), x])}
      end

      def exsit?(path)
       FileTest.exist?(path)
      end

      def maked(d)
        FileUtils.mkdir_p(d)
      end

    end

    class CheckVAndPath

      def self.yourenv
        a =
        {
          :lang =>ENV["LANG"],
          :term =>ENV["TERM_PROGRAM"],
          :ruby_v =>RUBY_VERSION,
          :releasedate =>RUBY_RELEASE_DATE
        }
      end

      def self.data_dir_check
        x = MyPath.new
        x.each{|dir|
          case dir[0]
          when true
            puts "OK: #{dir[1]}"
          else
            FileUtils.mkdir_p(dir[1])
            puts "Maked directory : #{dir[1]}"
          end
        }
        x.check
      end

    end

  end

end
