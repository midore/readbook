module ReadBook

  #####################
  # Search
  #####################

  class ItemSearch

    include ListCtl

    def initialize(word=nil, num=nil)
      @word = word
      @num = nil # 2009-01-28
      @num = num.to_i unless num.nil?
    end

    def base_search
      check_base
      a = get_ary
      return print "not found.\n" unless a
      @data.view(a){|x| x.to_s}
      SearchContinue.new.base_continue(a)
    end

    def as_search
      check_base
      a = get_ary
      return nil unless a
      a.each{|x| x.to_s_as}
    end

    private

    def check_base
      @data = MyList.listread
      raise "List is Empty." if @data.list.empty?
      raise "Error: Number." if @num == 0
      return true
    end

    def get_ary
      w = regexp_check
      ary = @data.find_word(w)
      return nil if ary.empty?
      return ary unless @num
      return ary[0..(@num-1)]
    end

    def regexp_check
      begin
        ustr = @word.encode("UTF-8")
        return false unless ustr.valid_encoding?
        w = Regexp.new(ustr, true)
        return w
      rescue RegexpError
        return nil
      end
    end

  end

  class SearchContinue

    def base_continue(ary)
      @item = chooseitem(ary)
      ans = select_con
      raise "stopped search." unless ans
      SearchOption.option(@item, ans)
    end

    private

    def chooseitem(ary)
      # no = $stding.gets = select NO. from items.
      return ary[0] if ary.size == 1
      no = select_no(ary.size)
      raise "stopped select item." unless no
      return ary[no - 1]
    end

    def select_no(n)
      str =  "\n: Please Select Number: [num/n]"
      return StdinGets.new.message(str, n)
    end

    def select_con
      return false if @item.nil?
      print "\n: Selected \"#{@item.title}\"\n"
      print "\n\: open[o] cat[c] update[u] remove[r] stop[n]."
      str =  " Please Select Option:[o/c/u/r/n]"
      return stg = StdinGets.new.message(str, false)
    end

  end

  class SearchOption

    class << self

      def opt_open(path)
        raise "Error: not exist file" unless path
        OpenMyFile::MySysOpen.openmyfile(path)
        path = nil
      end

      def option(i=nil, ans=nil)
        case ans
        when /^o$/
          path = TextCtl::MyText.get_textpath(i.ean)
          opt_open(path)
        when /^u$/
          ItemUpdate.new(i.ean.to_s).base_update
        when /^r$/
          ItemRemove.new(i.ean.to_s).base_remove
        when /^c$/
          path = TextCtl::MyText.get_textpath(i.ean)
          print "\n :TextFile:#{path}\n"
          i.detail
          path = nil
        when /^i$/
          print i.to_txt_associate
        end

      end

    end

  end

  class TextSearch < ItemSearch

    def base_search
      return nil unless check_base
      a = get_ary_memo
      return nil unless a
      @data.view(a){|x| x.to_s}
      SearchContinue.new.base_continue(a)
    end

    private

    def get_ary_memo
      ary = []
      w = regexp_check
      res = TextCtl::MyText.get_textmemo(w)
      return nil if res.empty?
      res.each{|k| ary << @data[k]}
      return ary unless @num
      return ary[0..@num-1]
    end

  end

end
