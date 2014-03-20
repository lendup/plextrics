class API < Grape::API
  logger Logger.new(STDOUT)

  version 'v1', using: :header, vendor: 'reader'
  format :json
  content_type :plx, "application/logplex-1"


  get do
    'Ok'
  end

  post ':service' do
    events = Payload.parse(request.env['rack.input'].read)
    service = "Service::#{params[:service].capitalize}".constantize.new(params)
    service.log(events)
  end
end
