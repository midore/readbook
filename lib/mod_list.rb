module ReadBook

  module ListCtl

    class MyList

      class << self

        include ReadBookConfig

        def listsave(data)
          path = filesubject
          raise "DirError: Can't access Dir." unless check_dir?(File.split(path)[0])
          check_list(path) if FileTest.exist?(path)
          # MarshalData Write
          f = open(path, "w")
          Marshal.dump(data, f)
          f.close
          sleep 1
          print ": Saved List.\n"
          return f.closed?
          ########################
          #File.open(path, "w+"){|f|
          #  f.flock(File::LOCK_EX)
          #  Marshal.dump(data, f)
          #}
          ########################
        end

        def listread
          path = filesubject
          data,ans = BaseList.new,nil
          raise "DirError: Can't access Dir." unless check_dir?(File.split(path)[0])
          check_list(path) if FileTest.exist?(path)
          return data unless FileTest.exist?(path)
          f = open(path, "r")
          ans = Marshal.load(f)
          f.close
          data.list = ans
          return data
          ########################
          #File.open(path){|f|
          #  f.flock(File::LOCK_SH)
          #  ans = Marshal.load(f)
          #}
          #data.list = ans
          #return data
          ########################
        end

        def viewcnt
          cntview
        end

        def awsid
          aws_id
        end

        def awskey
          aws_key
        end

        private

        def filesubject
          file_subject
        end

        def check_dir?(d)
          str = "not exist data directory.\n=>#{d}\nSetUpRun: readbook-setupdir.rb\n"
          return print str unless FileTest.exist?(d)
          return false unless FileTest.directory?(d)
          return false unless FileTest.readable?(d)
          return false unless FileTest.writable?(d)
          return false unless File.executable?(d)
          return true
        end

        def check_list(path)
          raise "FileError: it's directory. not file.\nFile: #{path}" if FileTest.directory?(path)
          raise "FileError: file permission.\nFile: #{path}" if File.executable?(path)
          raise "FileError: can not read list.\nFile: #{path}" unless FileTest.readable?(path)
          raise "FileError: can not write list.\nFile: #{path}" unless FileTest.writable?(path)
          raise "FileError: list size is zero.\nFile: #{path}" if FileTest.size(path) == 0
          raise "FileError: list name.\nFile: #{path}" unless File.extname(path) =~ /.obj$/
        end

      end

    end

  end

end