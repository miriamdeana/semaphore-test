require 'callrail_api'

class CallrailApiWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(callrail_id)
		api = CallrailApi.new(callrail_id).get_call
		tags = api["tags"]
    answered = api["answered"]

    if tags.blank?
      if answered || answered.nil?
        puts "#{answered}, #{tags}"
        CallrailApiWorker.perform_in(5.seconds, callrail_id)
      end

    elsif tags[0]["name"] == "Support" || tags[0]["name"] == "Billing"
      if answered
        #NEXT STEP: Figure out who the agent is
      elsif answered.nil?
        puts "#{answered}, #{tags}"
        CallrailApiWorker.perform_in(5.seconds, callrail_id)
      end
    end
	end
end
