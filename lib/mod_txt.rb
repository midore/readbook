module ReadBook

  module TextCtl

    class MyText

      class << self

        include ReadBookConfig
        include FileIndex

        def helptext
          @path = filehelp
          raise "Error: Help File" unless @path
          doc = read_file
          raise "Error: can't read HelpFile" unless doc
          print doc
        end

        def get_textpath(ean) # ItemAdd,SearchOption
          return txtpath(dir_text, ean) # mod fileIndex
        end

        def get_textmemo(w) # TextSearch
          ary = []
          indexfiles(dir_text).each{|k,v|
            @path = v
            h = TextItem::TextToH_m.setup(get_textdata)
            m = w.match(h.values.to_s) unless h.empty?
            ary << h.keys[0] if m
          }
          return ary
        end

        def get_textitem(ean) # ItemUpdate
          @path =  get_textpath(ean)
          data = get_textdata
          h = TextItem::TextToH.setup(data)
        end

        def save_data(i) # ItemAdd
          return nil if get_textpath(i.ean)
          @item = i
          @path = set_path
          @data = @item.to_txt
          write_file
        end

        private

        def get_textdata
          raise "Error: not exist text file" unless @path
          raise "Error: can't read file" unless get_check_file?
          return read_file
        end

        def get_check_file?
          return nil unless FileTest.readable?(@path)
          return nil if File.executable?(@path)
          return nil unless File.extname(@path) =~ /^\.txt$/
          m = /^[1-9].*?\.txt$/.match(File.split(@path)[1])
          return nil unless m
          return true
        end

        def read_file
          # reference: http://doc.loveruby.net/refm/api/view/method/Encoding/s/locale_charmap
          content = ""
          File.open(@path, 'r:UTF-8'){|f|
            f.flock(File::LOCK_SH)
            content = f.read
          }
          raise "Error: empty data" if content.empty?
          raise "Error: read only utf-8" unless content.encoding.name == "UTF-8"
          return content
        end

        def write_file
          raise "Error Encoding data" unless @data.encoding.name == 'UTF-8'
          File.open(@path, File::WRONLY | File::CREAT){|f|
            f.flock(File::LOCK_EX)
            f.print @data
          }
          sleep 2
        end

        def set_path
          ext = @item.title.gsub(/\(.*?\)|\s|\.|:|;|#|%|&|$|@|!/u,'').gsub(/\//,'_')
          path = File.join(dir_text, @item.ean.to_s + "-" + ext + '.txt')
          #path.force_encoding("UTF8-MAC") unless ext.ascii_only?
          return path
        end

        def filehelp
          file_help
        end

        def textdir
          dir_text
        end

      end

    end

  end

  module OpenMyFile

    ##############################
    # open text file # SearchOption
    ##############################

    class MySysOpen

      def self.openmyfile(path)
        raise "Error: open file" unless check_open?(path)
        begin
          system("open #{path}")   # OS X TextEdit.app
        rescue Exception => err
        end
      end

      def self.check_open?(path)
        return nil unless path
        return nil unless FileTest.exist?(path)
        return nil unless File.extname(path) =~ /.txt$/
        return nil unless FileTest.readable?(path)
        f = File.basename(path)
        m = /^[1-9].?(.*?)\.txt/.match(f)
        return nil unless m
        return true
      end

      private_class_method :check_open?

    end

  end

  module TextItem

    ##############################
    # text to hash
    # use only MyText
    ##############################

    class TextToH

      def self.setup(str)
        return nil if str.empty?
        k,val,th = nil,'',{:@ean=>nil, :@enddate=>nil, :@memo=>nil, :@genru=>nil}
        str.each_line{|line|
          if line =~ /^--memo\n$|^--genru\n$|^--ean\n$|^--enddate\n$/
            k = line.chomp.gsub("--",'@').downcase.to_sym
          next
          else
            th[k] ||= line.strip.encode("UTF-8") unless line.strip.empty?
          end
        }
        th[:@ean] = th[:@ean].to_i unless th[:@ean].nil?
        th[:@genru] = "-".encode("UTF-8") if th[:@genru].nil?
        th[:@memo] = "-".encode("UTF-8") if th[:@memo].nil?
        th[:@memo] = "+".encode("UTF-8") unless th[:@memo] == "-"
        return th
      end

    end

    ##############################
    # memo text to hash {ean=>memo}
    # use only MyText
    ##############################

    class TextToH_m

      def self.setup(str)
        return nil if str.nil?
        k,ean,val,h = nil,nil,'',{}
        str.each_line{|line|
          if line =~ /^--ean\n|^--memo\n$/
            k = line.chomp.gsub("--",'')
            next
          else
            ean ||= line.chomp
            val << line if k == "memo"
          end
        }
        h[ean.to_i] = val.strip
        return h
      end
    end

  end

end
