module ReadBook

  #####################
  # AppleScript
  #####################

  class ForAppleScript

    def initialize(opt1=nil, opt2=nil)
      @com = opt1
      @opt2 = opt2
    end

    def base_as
      case @com
      when /^a$/
        as_add
      when /^s$/
        as_s
      when /^f$/
        as_f
      when /^list$/
        as_list
      when /^last$/
        as_last
      when /^u$/
        as_update
      when /^o$/
        as_open
      end
      return
    end

    private

    def as_list
      ItemShow.new(@opt2).as_view_list
    end

    def as_last
      ItemShow.new(@opt2).as_view_last
    end

    def as_update
      ItemUpdate.new('100000001').base_update
    end

    def as_add
      @opt2 = @opt2.gsub("-", '')
      ItemAdd.new(@opt2).base_add
    end

    def as_s
      ItemSearch.new(@opt2, '10').as_search
    end

    def as_f
      TextSearch.new(@opt2, '10').as_search
    end

    def as_open
      puts @opt2
    end

  end

end