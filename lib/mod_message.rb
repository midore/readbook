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
        return false if ans.size > 1
        return false if ans == "0"
        return false if ans =~ /\D/
        ans = snumtonum(ans)
        return false unless ans
        return false if ans > opt.to_i # Max Numbera
        return ans
      end
    end

    def snumtonum(str)
      #ref: 'Ruby Way' SecondEdition P122.
      ary = (65296..65305).to_a
      c = str.codepoints.to_a[0]
      (c > 128) ? ary.index(c): str.to_i
    end

  end

end