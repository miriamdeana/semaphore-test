require 'httparty'

class CallRailAPI 
    include HTTParty
    base_uri 'https://api.callrail.com/v2/a/266101466'
end