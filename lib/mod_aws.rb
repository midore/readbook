module ReadBook

  module Aws

    class Amazon

      def initialize(str=nil)
        unless str.nil?
          case str.encoding.name
          when "UTF-8"
            ustr = str
          else
            ustr = str.force_encoding("UTF-8")
          end
          raise "Error: xml data" unless ustr.valid_encoding?
          @xml = REXML::Document.new(ustr)
        end
        @h = Hash.new
        @i = nil
      end

      def item
        return nil unless @xml.to_s.encoding.name == "UTF-8"
        dh = data_to_h
        unless dh.nil?
          @i = selectitem
          return nil if @i.nil?
          @i.setup.call(@h)
          return @i
        end
      end

      private

      def selectitem
        g = @h["ProductGroup"]
        return Book.new if g == "Book"
        return Music.new if g == "Music"
      end

      def data_to_h
        return nil unless @xml
        return nil if @xml.to_s =~ /Error/
        return nil unless @xml.encoding == "UTF-8"
        getelement
        set_data
        return @h
      end

      def getelement
        ei = @xml.root.elements["Items/Item"]
        @attrib = get(ei, "ItemAttributes")
        @img = get(ei, "MediumImage")
        @url = get(ei, "DetailPageURL")
      end

      def set_data
        @attrib.each{|x| @h[x.name] = plural(@attrib,x.name)}
        @h.delete_if{|k,v| v.nil?}
        setprice
        setimg
        seturl
        @h["EAN"] = @h["EAN"].to_i
        @h["ISBN"] = @h["ISBN"].to_i unless @h["ISBN"].nil?
        @h["price"] = @h["price"].to_i
      end

      def get(ele, str)
        ele.elements[str]
      end

      def plural(ele, str)
        e = ele.get_elements(str)
        case e.size
        when 0
        when 1
          ele.elements[str].text
        else
          @h[str] = e.map{|i| i.text}.join(" / ")
        end
      end

      def setprice
        @h["price"] = @attrib.elements["ListPrice/FormattedPrice"].text.gsub(/\D/,'')
      end

      def setimg
        @h["mediumimage"] = @img.elements["URL"].text unless @img.nil?
      end

      def seturl
        url = exurl(@url.text)
        return nil unless url.encoding.name == "UTF-8"
        tag = /\&(tag=.*?)\&/.match(url)[1]
        eurl = url.gsub(/\?SubscriptionId=.*/u,'')
        m = /amazon.co.jp\/(.*?\/)/u.match(eurl)
        @h["url"] = eurl.gsub(m[1],'') + "?" + tag
        # =>"http://www.amazon.co.jp/dp/4003402618?tag=midore-22"
      end

      def exurl(string)
        # reference: lib/ruby/1.9.0/cgi/util.rb #line.15
        enc = string.encoding
        string.gsub(/%([0-9a-fA-F]{2})/){[$1.delete('%')].pack("H*")}.force_encoding(enc)
      end

    end

    class Seturi

      def initialize(aws_accessKeyId=nil, associate_ID=nil)
        @aws_key = aws_accessKeyId
        @aws_id = associate_ID
        @jp_ecs = 'http://ecs.amazonaws.jp'
        #http://ecs.amazonaws.jp/onca/xml?Service=AWSECommerceService
      end

      def seturi(ean)
        return nil unless @aws_key
        return nil unless @aws_id
        uri = URI.parse(@jp_ecs)
        uri.path='/onca/xml'
        q = [
          "Service=AWSECommerceService",
          "AWSAccessKeyId=#{@aws_key}",
          "Operation=ItemLookup",
          "ItemId=#{ean}",
          "AssociateTag=#{@aws_id}",
          "ResponseGroup=Medium"
        ]
        ean = ean.to_s
        case ean.size
        when 10
          q << ["SearchIndex=Books" ,"IdType=ISBN"]  # Book isbn 10
        when 12
          q << ["SearchIndex=Music", "IdType=EAN"]   # Not japanese CD
        when 13
          if ean.to_s =~ /^978|^491/                 # Book isbn 13 (EAN)
            q << ["SearchIndex=Books" ,"IdType=EAN"]
          elsif ean.to_s =~ /^458/                   # japanese DVD
            q << ["SearchIndex=DVD", "IdType=EAN"]
          else
            q << ["SearchIndex=Music", "IdType=EAN"] # Japanese CD
          end
        end
        uri.query = q.join("&")
        return uri
      end

    end

    class Access

      def initialize(uri)
        @host = uri.host
        @request = uri.request_uri
      end

      def reponse
        res = ""
        begin
          Net::HTTP.start(@host){|http|
            response = http.get(@request)
            res = response.body
          }
          raise "Error: AWS access." unless res
        rescue SocketError
          return 'socket'
        rescue Exception =>error
          return error
        end
        return res
      end

    end

  end

end
