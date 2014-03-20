class Service::Stathat < Service
  attr_reader :ezkey

  def initialize(params)
    super
    @ezkey = params[:ezkey]
  end

  def get_metric_name(event) 
  	name = event[:metric]
  	name = "#{event[:metric]}~total,#{event[:ps]}" if event.has_key? :ps
  	name
  end

  def count(event)
  	#puts "count: #{get_metric_name(event)}, #{event[:value]}"
	puts StatHat::API.ez_post_count(get_metric_name(event), ezkey, event[:value])
  end

  def gauge(event)
  	#puts "gauge: #{get_metric_name(event)}, #{event[:value]}"
  	puts StatHat::API.ez_post_value(get_metric_name(event), ezkey, event[:value])
  end
end
