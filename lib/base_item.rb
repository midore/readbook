module ReadBook

  class BaseItem

    attr_reader :group,:ean, :title, :author, :price ,:productgroup
    attr_accessor :memo, :genru, :adddate, :enddate

    def initialize
      @adddate = Time.now.strftime("%Y-%m-%d").encode("UTF-8")
      @enddate = nil
    end

    def setup
      # ItemAdd
      Proc.new do |h|
        h.each{|k,v|
          s = "@#{k}".downcase.to_sym
          set_ins(s,v)
        }
        set_ins(:@genru,"-")
        set_ins(:@memo,"-")
      end
    end

    def str_values
      # BaseList#find_word
      ary = []
      self.instance_variables.each{|v|
        unless /url|mediumimage/.match(v.to_s)
          val = instance_variable_get(v)
          ary << val unless val.nil?
        end
      }
      return ary.join("_")
    end

    def detail
      # SearchOption c
      self.instance_variables.each{|v|
        name = v.to_s.gsub("@",'')
        val = instance_variable_get(v)
        sval = val.to_s.strip
        print " :#{name} :#{sval.strip}\n"
      }
      return nil
    end

    def to_txt
      com_txt(ary_txt)
    end

    def to_txt_associate
      @price = comma
      au = au_cre_art
      str = String.new.encode("UTF-8")
      str =<<-EOF
      ...pending...
      EOF
      print str
    end

    def to_s
      #price = "\u{A5}" + comma
      #d = @adddate[5..9].gsub("-","/")
      au = au_cre_art
      @enddate = '-' unless @enddate
      @enddate = @enddate.to_s[0..9]
      @genru = @genru[0..15]
      ary = [@productgroup,@enddate,@memo,@genru,@title,au]
      printf "\t[%-5s][%-010s][%s][%-016s]\s\s%s\s|\s%s\n" % ary
    end

    def to_s_as
      # for applescript 2
      print "#{@ean.to_s}: #{@title}\n"
    end

    private

    def m_def?(i)
      self.class.method_defined? m
    end

    def i_defined?(v)
      self.instance_variable_defined?(v)
    end

    def comma
      return nil if /[^0-9]/.match(@price.to_s)
      str = @price.to_s
      s = str.size
      res, k = [], (s - 4) % 3
      ary = str.chars.to_a
      ary.each_index{|x|
        res << ary[x]
        (x == k and x + 1 < s) ? (k, res = k + 3, res << ",") : k
      }
      return res.join('')
    end

    def au_cre_art
      b = ""
      a ||= @artist if i_defined?(:@artist)
      a ||= @author if i_defined?(:@author)
      (i_defined?(:@creator)) ? (b << "#{a}\s(#{@creator})") : b = a
      return b
    end

    def set_ins(i,val)
      val = val.encode("UTF-8") if val.kind_of?(String)
      self.instance_variable_set(i, val)
    end

    def com_txt(ary)
      str = String.new.encode("UTF-8") # 2009-01-18
      ary.each{|i|
        if i_defined?(i)
          val = instance_variable_get(i)
          str << lines = i.to_s.gsub("@","--") + "\n" + val.to_s + "\n"
        end
      }
      return str
    end

  end

  class Book < BaseItem

    private

    def ary_txt
      ary = [:@ean,:@title,:@author,:@creator,:@publisher,:@enddate, :@genru,:@memo]
      ary.delete(:@author) unless i_defined?(:@author)
      ary.delete(:@creator) unless i_defined?(:@creator)
      return ary
    end

    def ary_associate
      ary = [:@title,:@url,:@mediumimage,:@price, :@author,:@creator,:@publisher]
      ary.delete(:@creator) unless i_defined?(:@creator)
      return ary
    end

  end

  class Music < BaseItem

    private

    def ary_txt
     return [:@ean,:@title,:@artist,:@label,:@enddate,:@genru,:@memo]
    end

    def ary_associate
      ary = [:@title,:@url,:@mediumimage,:@price, :@artist,:@creator,:@label]
      ary.delete(:@creator) unless @creator
      return ary
    end

  end

end
