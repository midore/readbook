module ReadBook

  #####################
  # EAN
  #####################

  class Ean

    include ListCtl

    def initialize(ean=nil, str=nil)
      @ean = ean_check(ean)
      @item = nil
      @data = MyList.listread # marshal data read
    end

    def ean_check(ean)
      numerror = nil
      unless ean.nil?
        ean = ean.gsub("-",'')
        # not ascii　number
        ean.codepoints.to_a.each{|x| numerror = true if x > 57 or x < 48}
        return nil if numerror
        return nil if ean.size < 9 or ean.size > 13
        return nil if m = /\D/.match(ean)
        @ean = ean.to_i
      end
    end

    private :ean_check

  end

  #####################
  # Add, Remove
  #####################

  class ItemAdd < Ean

    def base_add
      return nil unless @ean
      check_datalist
      @item = @data[@ean]
      unless @item
        step_add
        step_save
      else
        step_notadd
      end
      sleep 1
      step_text_open if @clearlist
    end

    private

    def item
      a = UseAmazon.new(@ean)
      a.aws_id = MyList.awsid
      a.aws_key = MyList.awskey
      return a.item
    end

    def step_add
      @item = item
      check_item
      @data[@item.ean] = @item
    end

    def step_save
      @clearlist = MyList.listsave(@data.list)
      TextCtl::MyText.save_data(@item) if @clearlist
      print ": Added Item.\n#{@item.title}\n"
    end

    def step_text_open
      @ean = @item.ean unless @ean == @item.ean
      path = TextCtl::MyText.get_textpath(@ean)
      SearchOption.opt_open(path)
    end

    def step_notadd
      @clearlist = true
      print ": Exist item\n #{@item.title} .\n"
    end

    def check_item
      raise "Error: AWS GET Error => #{@ean} ." unless @item
      raise "Error: EAN." unless @item.ean
    end
    
    def check_datalist
      raise "Error: list problem." unless @data
      print "Hello, readbook\n" if @data.list.empty?
    end

  end

  class ItemsAdd < ItemAdd

    def base_add(path)
      raise "Error: path." unless FileTest.exist?(path)
      @cnt = 0
      IO.readlines(path).each{|n|
        next if /#/.match(n.chomp)
        unless n.chomp.empty?
          @ean = ean_check(n.chomp)
          base_add_s
        end
      }
      MyList.listsave(@data.list) if @cnt > 0
    end

    private

    def base_add_s
      return nil unless @ean
      check_datalist
      @item = @data[@ean]
      unless @item
        step_add
        TextCtl::MyText.save_data(@item)
        print ": Added Item.\n#{@item.title}\n waiting 3 sec... \n"
        sleep 3
        @cnt += 1
      else
        return print "item exist. #{@item.title}\n"
      end
    end

  end

  #####################
  # Amazon
  #####################

  class UseAmazon

    include Aws

    attr_accessor :ean, :aws_id, :aws_key

    def initialize(ean=nil)
      @ean = ean
      @aws_key = nil
      @aws_id = nil
    end

    def item
      return nil unless @ean
      doc = getdoc
      return nil unless doc
      return nil if doc.empty?
      return nil if doc == "socket"
      a = Amazon.new(doc)
      return a.item
    end

    private

    def getdoc
      url = Seturi.new(@aws_key, @aws_id).seturi(@ean)
      doc = Access.new(url).reponse
      return doc
    end

  end

  #####################
  # Remove
  #####################

  class ItemRemove < Ean

    def base_remove
      return nil unless @ean
      return nil unless @data
      raise "List is Empty." if @data.list.empty?
      print @ean, "\n"
      @item = @data[@ean]
      str =  "\n: Remove \"#{@item.title}\"  OK? [y/n]"
      return print "\nnot found item of list.\n" unless @item
      return nil unless mess_remove(str)
      item_remove
      print ": Removed Item #{@item.title}\n"
    end

    private

    def mess_remove(str)
      return StdinGets.new.message(str, true)
    end

    def item_remove
      @data.delete(@ean)
      MyList.listsave(@data.list)
    end

  end

end