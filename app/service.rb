class Service

  def log(events)
    events.each do |event|
      if event[:type] == 'sample'
        gauge(event)
      else
        count(event)
      end
    end
  end

  def initialize(params)
    @params = params
  end

  def count(metric)
    raise 'Not implemented'
  end

  def gauge(metric, value)
    raise 'Not implemented'
  end
end
