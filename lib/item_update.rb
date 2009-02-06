module ReadBook

  #####################
  # Update
  #####################

  class ItemUpdate < Ean

    def base_update
      @cnt = 0
      return nil unless @ean
      return nil unless @data
      raise "List is Empty." if @data.list.empty?
      return all_update if @ean == 100000001
      one_update
    end

    private

    def one_update
      @item = @data[@ean]
      return nil if @item.nil?
      @cnt = item_update unless check_item
      list_update
    end

    def all_update
      @data.list.keys.each{|ean|
        @ean,@item = ean,@data[ean]
        next if @item.nil?
        @cnt = item_update unless check_item
      }
      list_update
    end

    def check_item
      @gt = get_txt_data
      @gl = get_list_data
      return true unless @gt or @gl
      @gl.eql?(@gt)
    end

    def item_update
      @cnt += 1 if item_replace
      return @cnt
    end

    def item_replace
      return print "Error: EAN of text." unless @ean == @gt[:@ean] # check ean of text file
      @item.memo = @gt[:@memo]
      @item.genru = @gt[:@genru]
      @item.enddate = @gt[:@enddate]
      @data[@ean] = @item
      print ": Updated #{@item.title}.\n"
      return true
    end

    def get_txt_data
      return TextCtl::MyText.get_textitem(@ean)
    end

    def get_list_data
      return {:@ean=>@item.ean, :@enddate=>@item.enddate, :@memo=>@item.memo, :@genru=>@item.genru}
    end

    def list_update
      MyList.listsave(@data.list)  if @cnt > 0
    end

  end
  
end