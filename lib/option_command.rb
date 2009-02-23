module ReadBook

  #####################
  # Starter
  #####################

  class Starter

    def Starter.start
      OptionCommand.caseopt
    end

  end

  #####################
  # Command Option
  #####################

  class OptionCommand

    def self.caseopt
      return print "see: help.\n" if ARGV.empty?
      com,opt1,opt2,opt3 = ARGV
      s = ARGV.size
      raise "see: help." if s > 4
      case s
      when 1
        group_1(com)
      when 2
        group_2(com, opt1)
      when 3
        group_3(com, opt1, opt2)
      else
        raise "see: help.\n"
      end
    end

    private

    def self.group_1(com)
      # opt1 is nil
      case com
      when /^h$|^help$/
        MyHelp.help
      when /^l$/
        ItemShow.new.base_list
      when /^last$/
        ItemShow.new.base_last
      else
        raise "see: help."
      end
    end

    def self.group_3(com, opt1, opt2)
      # opt1 is keyword & opt2 is num
      raise "keyword > 13 size." if opt1.size > 13
      case com
      when /^s$/
        ItemSearch.new(opt1, opt2).base_search
      when /^f$/
        TextSearch.new(opt1, opt2).base_search
      when /^as$/
        ForAppleScript.new(opt1, opt2).base_as
      end
    end
 
    def self.group_2(com, opt1)
      # opt1 is ean or keyword
      raise "keyword size > 13." if opt1.size > 13
      case com
      when /^l$/
        ItemShow.new(opt1).base_list
      when /^last$/
        ItemShow.new(opt1).base_last
      when /^s$/
        ItemSearch.new(opt1, nil).base_search
      when /^f$/
        TextSearch.new(opt1, nil).base_search
      when /^r$/
        ItemRemove.new(opt1).base_remove
      when /^a$/
        ItemAdd.new(opt1).base_add
      when /^u$/
        opt1 = '100000001' if opt1 =~ /^all$/
        ItemUpdate.new(opt1).base_update
      when /^fadd$/
        ItemsAdd.new.base_add(opt1)
      end
    end

  end

  ######################
  # help
  ######################

  class MyHelp

    def self.help
      TextCtl::MyText.helptext
      print "[About #{MYNAME}] \n"
      print "Copyright: #{COPYRIGHT}\n"
      print "LastDate: #{DATE}\n"
      print "Version: #{VERSION}\n"
      print "License: You can redistribute it and/or modify it under the same terms as Ruby.\n\n"
    end

  end

end
