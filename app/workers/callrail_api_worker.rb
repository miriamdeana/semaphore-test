require 'callrail_api'

class CallrailApiWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(callrail_id)
		api = CallrailApi.new(callrail_id).get_call
		tags = api["tags"]
    answered = api["answered"]

    #puts "#{api}"

    if tags.blank?
      # Check if call has been answered. If not, end.
      case answered
      when false
        puts "#{callrail_id} No answer (#{answered}) or client hung up, were there any tags? #{tags}. End."
      when true
        puts "#{callrail_id} Answered (#{answered}) but no tags (#{tags}), try again in 5 seconds"
        CallrailApiWorker.perform_in(5.seconds, callrail_id)
      else
        puts "#{callrail_id} No answer (#{answered}) and no tags (#{tags}), try again in 5 seconds"
        CallrailApiWorker.perform_in(5.seconds, callrail_id)
      end

    elsif tags[0]["name"] == "Support" || tags[0]["name"] == "Billing"
      # Check if call has been answered. If not, end.
      case answered
      when false
        puts "No answer (#{answered}) or client hung up, were there any tags? (#{tags[0]["name"]}) End."
      when true
        puts "Answered (#{answered}) and it was tagged appropriately (#{tags[0]["name"]}). Next step."
        # NEXT STEP: figure out who is the agent.
      else
        puts "No answer (#{answered}) but tagged appropriately (#{tags[0]["name"]}), try again in 5 seconds"
        CallrailApiWorker.perform_in(5.seconds, callrail_id)
      end

    else
      puts "Not tagged Support or Billing (#{tags[0]["name"]}). End."
    end

	end
end
