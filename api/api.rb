class API < Grape::API
  logger Logger.new(STDOUT)

  version 'v1', using: :header, vendor: 'reader'
  format :json
  content_type :plx, "application/logplex-1"


  get do
    'Ok'
  end

  post ':service' do
    service = "Service::#{params[:service].capitalize}".constantize.new(params)
    request.env['rack.input'].each do |line|
      payload = Payload.parse(line)
      service.log(payload) if !payload.nil?
    end
    'OK'
  end
end
