module ReadBook

  module ReadBookConfig

    include $RBCONF

    private

    def h
      self.conf.h
    end

    def dir_base
      h[:dir_base]
    end

    def file_help
      File.join(dir_base, 'bin', 'help.txt')
    end

    def dir_data
      File.join(dir_base, h[:dir_data])
    end

    def dir_text
      File.join(dir_data, h[:dir_text])
    end

    def dir_subject
      File.join(dir_data, h[:dir_subject])
    end

    def file_subject
      File.join(dir_subject, h[:file_subject])
    end

    def cntview
      h[:count_view]
    end

    def aws_id
      h[:aws_id]
    end

    def aws_key
      h[:aws_key]
    end

  end

end
