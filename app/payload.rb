class Payload
  LineRe = /^\d+ \<\d+\>1 (\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?\+00:00) [a-z0-9-]+ ([a-z0-9\-\_\.]+) ([a-z0-9\-\_\.]+) \- (.*)$/
  IgnoreMsgRe = /(^ *$)|(Error|Processing|Parameters|Completed|\[Worker\(host)/
  TimeSubRe = / \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d-\d\d:\d\d/
  AttrsRe = /( *)(sample|count)#([a-zA-Z0-9\_\-\.]+)=?(([a-zA-Z0-9\.\-\_\.]+)|("([^\"]+)"))?/
  RouterAttrsRe = /( *)([a-zA-Z0-9\_\-\.]+)=?(([a-zA-Z0-9\.\-\_\.]+)|("([^\"]+)"))?/

  class << self

    def unpack(input)
      while input && input.length > 0
        if m = input.match(/^(\d+) /)
          num_bytes = m[1].to_i
          msg = input[m[0].length..(m[0].length + num_bytes)]
          if data = parse([m[0], msg.chomp].join)
            puts 'hello!'
          end
          input = input[(m[0].length + num_bytes)..(input.length)]
        elsif m = input.match(/\n/)
          input = m.post_match
        else
        end
      end
    end

    def parse(line)
      if m = line.match(LineRe)
        events = parse_msg(m[5], m[4])
        events = events.map { |event| 
          event[:time] = Time.parse(m[1])
          event[:source] = m[3]
          event[:ps] = m[4] if m[4] != 'router'
          event[:value] = event[:value].gsub(/[^\d\.]/, "")
          event[:type] 
          event
        } if !events.nil?
        events
      end
    end

    def parse_msg(msg, ps)
      if !msg.match(IgnoreMsgRe)
        data = []
        if ps == 'router' then
          msg.scan(RouterAttrsRe) do |_, key, _, val1, _, val2|
            datum = {}
            datum[:metric] = "router." + key  
            datum[:value] = val1      
            case key
            when "service", "connect"
              datum[:type] = "sample"
            when "bytes"
              datum[:type] = "count"
            end
            data << datum if datum.has_key? :type
          end
        else
          msg.scan(AttrsRe) do |_, type, key, _, val1, _, val2|
            datum = {}
            datum[:metric] = key          
            datum[:type] = type
            if (((key == "service") || (key == "wait")) && val1)
              val1 = val1.sub("ms", "")
            end
            datum[:value] = (val1 || val2 || "1")              
            data << datum
          end
        end
        data
      end
    end

  end
end
