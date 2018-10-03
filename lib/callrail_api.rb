require 'httparty'

class CallrailApi 
  include HTTParty

  def initialize(callrail_id)
    @callrail_id = callrail_id
  end
  
  def get_call
    response = HTTParty.get("https://api.callrail.com/v2/a/266101466/calls/#{@callrail_id}.json?fields=tags,agent_email",
                              :headers => { "Authorization" => "Token token=#{Rails.application.credentials.callrail_api_key}" })
    json = JSON.parse(response.body)
  end
end