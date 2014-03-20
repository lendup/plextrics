class Service::Stathat < Service
  attr_reader :ezkey

  def initialize(params)
    super
    @ezkey = params[:ezkey] 
    EM::StatHat.config do |c|
    	c.ukey = "none"
    	c.email = params[:ezkey]    	
    	unless EventMachine.reactor_running? && EventMachine.reactor_thread.alive?
    		puts "Starting reactor..."
    		Thread.new { EventMachine.run }
    		sleep 1
  		end
    end
  end

  def get_metric_name(event) 
  	name = event[:metric]
  	name = "#{event[:metric]}~total,#{event[:ps]}" if event.has_key? :ps
  	name
  end

  def count(event)
		puts "#{ezkey} count: #{get_metric_name(event)}, #{event[:value]}"
		EM::StatHat.new('https://api-stathat-com-i8n2zh1nklna.runscope.net').ez_count(get_metric_name(event), event[:value])
  end

  def gauge(event)
  	puts "#{ezkey} gauge: #{get_metric_name(event)}, #{event[:value]}"
		EM::StatHat.new('https://api-stathat-com-i8n2zh1nklna.runscope.net').ez_value(get_metric_name(event), event[:value])
  end
end
