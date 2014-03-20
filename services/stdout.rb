class Service::Stdout < Service
  attr_reader :ezkey

  def initialize(params)
    super
  end

  def count(event)
    puts "count: #{event}"
  end

  def gauge(event)
    puts "gauge: #{event}"
  end
end
