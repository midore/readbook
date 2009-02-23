module ReadBook

  module BaseMessage

    def interactive(mess, opt)
      return false unless $stdin.tty?
      print "#{mess}:\n"
      ans = $stdin.gets.chop
      return false if /^n$|^no$/.match(ans) # n or no == stop
      return false if ans.empty?
      case opt
      when true   # yes or no
        m = /^y$|^yes$/.match(ans)
        return false unless m
        return true
      when false  # return alphabet
        return false if /\d/.match(ans)
        return false if ans.size > 1
        return ans
      else        # return number
        # ignore zenkaku suji. 2009-02-09.
        i_ans = ans.to_i
        return false if i_ans > opt
        return false if ans == "0"
        return false if ans =~ /\D/
        return false unless ans
        return ans.to_i
      end
    end

  end

end