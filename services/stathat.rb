class Service::Stathat < Service
  attr_reader :ezkey

  def initialize(params)
    super
    @ezkey = params[:ezkey]
  end

  def count(metric)
	StatHat::API.ez_post_count(metric, ezkey, value)
  end

  def gauge(metric, value)
  	StatHat::API.ez_post_value(metric, ezkey, value)
  end
end
