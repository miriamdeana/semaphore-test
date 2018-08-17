# require 'httparty'

# class CallrailApi 
#     include HTTParty
#     base_uri 'https://api.callrail.com/v2/a/266101466/calls/'

#     def initialize(callrail_id)
#         @callrail_id = callrail_id
#     end
    
#     def get_call
#         response = self.class.get("/calls/#{@callrail_id}.json?fields=tags",
#                                 :headers => { "Authorization" => "Token token=#{Rails.application.credentials.callrail_api_key}" })
#     end
# end