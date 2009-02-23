module ReadBook

  ######################
  # Message and gets
  # reference: http://doc.loveruby.net/refm/api/view/class/Timeout
  ######################

  class StdinGets

    include BaseMessage

    def message(str, opt)
      sec = 7
      ans = ''
      begin
        timeout(sec){ans = interactive(str, opt)}
      rescue RuntimeError
        raise "Timeout. #{sec}sec...bye"
      rescue SignalException
        raise "\n"
      end
      return ans
    end

  end

end