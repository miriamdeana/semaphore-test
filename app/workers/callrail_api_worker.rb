
require 'callrail_api'

class CallrailApiWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(callrail_id)
		api = ping_api(callrail_id)
		tags = api["tags"]
    answered = api["answered"]
    start_time = api["start_time"].to_datetime
    
    if Time.now.iso8601 < start_time + 2.minutes
      if tags.blank?
        if answered.nil?
          CallrailApiWorker.perform_in(5.seconds, callrail_id)
        end

      elsif tags.include? "Support"
        if answered
          #NEXT STEP: Figure out who the agent is
        elsif answered.nil?
          CallrailApiWorker.perform_in(5.seconds, callrail_id)
        end
      end
    end
  end
  
  def ping_api(callrail_id)
    CallrailApi.new(callrail_id).get_call
  end
end