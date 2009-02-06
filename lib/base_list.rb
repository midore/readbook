module ReadBook

  class BaseList

    attr_accessor :list

    def initialize
      @list = Hash.new
    end

    def [](ean)
      @list[ean]
    end

    def []=(ean, h)
      @list[ean] = h
    end

    def each
      @list.each{|k,v| yield(v)}
    end

    def view(ary)
      # ItemSearch
      return nil if ary.empty?
      ary.each_with_index{|i,no|
        n = (no + 1).to_s
        print n + "."
        yield(i)
      }
      print "----\n#{ary.size} items\n"
      return ary
    end

    def find_word(w)
      return nil unless w
      ary = @list.values.find_all{|v| w.match(v.str_values)
      }.sort_by{|x| x.enddate.to_s}.reverse
    end

    def delete(ean)
      @list.delete(ean)
    end

    def order_of_add(n=5)
      # 2009-01-30.
      return [] if n == 0
      s1 = @list.select{|k,v| v.enddate.nil?}.values.sort_by{|v| v.adddate}.reverse
      (s1.size < n) ? (s1 + (@list.values.to_a - s1).sort_by{|v| v.enddate}.reverse)[0..(n-1)] : s1[0..(n-1)]
    end

    def order_of_end(n=5)
      return [] if n == '0'
      @list.delete_if{|k,v| v.enddate.nil?}.values.sort_by{|v| v.enddate.to_s}.reverse[0..(n-1)]
    end

  end

end
