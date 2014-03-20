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
		StatHat::API.ez_post_count(get_metric_name(event), ezkey, event[:value]) do |r|
	    unless r.valid?
	      puts "Error sending data to StatHat.  Status #{r.status}, Message: #{r.msg}."
	    end
    end
  end

  def gauge(event)
  	StatHat::API.ez_post_value(get_metric_name(event), ezkey, event[:value]) do |r|
	    unless r.valid?
	      puts "Error sending data to StatHat.  Status #{r.status}, Message: #{r.msg}."
	    end
    end
  end
end
