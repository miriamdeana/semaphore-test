require 'callrail_api'

class CallrailApiWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(callrail_id)
		api = CallrailApi.new(callrail_id).get_call
		tags = api["tags"]
		answered = api["answered"]

		if answered == false
			puts "no answer or client hung up, were there any tags? #{tags[0]["name"]}"
		elsif answered == nil
			puts "Call hasn't been answered yet"
			CallrailApiWorker.perform_in(5.seconds, callrail_id)
		else
			puts "the callrail call id is #{callrail_id} and it is tagged #{tags[0]["name"]}"
		end
	end
end
