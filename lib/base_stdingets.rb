module ReadBook

  ######################
  # Message and gets
  # reference: http://doc.loveruby.net/refm/api/view/class/Timeout
  ######################

  class MyError < Exception; end

  class StdinGets

    include BaseMessage

    def message(str, opt)
      ans = ''
      begin
        timeout(9, MyError){ans = interactive(str, opt)}
      rescue MyError => err
        print "Timeout...bye.\n"
        return false
      end
      return ans
    end

  end

end