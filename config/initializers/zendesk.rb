require 'zendesk_api'

module Zendesk
  def self.client
    ZendeskAPI::Client.new do |config|
      # Mandatory:
      config.url = "https://callrail1472494564.zendesk.com/api/v2"
      # Basic / Token Authentication
      config.username = ENV['ZENDESK_USERNAME'];
      # # Choose one of the following depending on your authentication choice
      config.token = ENV['ZENDESK_TOKEN'];
      # config.password = "your zendesk password"

      # Retry uses middleware to notify the user
      # when hitting the rate limit, sleep automatically,
      # then retry the request.
      config.retry = true

      # Logger prints to STDERR by default, to e.g. print to stdout:
      require 'logger'
      config.logger = Logger.new(STDOUT)
    end
  end
end
