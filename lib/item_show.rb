module ReadBook

  #####################
  # ListViewer
  #####################

  class ItemShow

    include ListCtl

    def initialize(opt1=nil)
      @num = opt1.to_i
      @num = MyList.viewcnt unless opt1
    end

    def base_list
      check_base
      order_add
      return nil
    end

    def base_last
      check_base
      order_end
      return nil
    end

    def as_view_list
      check_base
      add_v.each{|x| x.to_s_as}
      return nil
    end

    def as_view_last
      check_base
      end_v.each{|x| x.to_s_as}
      return nil
    end

    private

    def check_base
      @data = MyList.listread
      raise "List is Empty." if @data.list.empty?
      raise "Error: Number." if @num == 0
    end

    def order_add
      @data.view(add_v){|x| x.to_s}
    end

    def order_end
      @data.view(end_v){|x| x.to_s}
    end

    def add_v
      @data.order_of_add(@num)
    end

    def end_v
      @data.order_of_end(@num)
    end

  end

end
