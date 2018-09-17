require 'callrail_api'

class CallrailApiWorker
	include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(callrail_id)
    api = ping_api(callrail_id)
    tags = api["tags"]
    answered = api["answered"]
    counter = 1

    loop do
      if (tags.blank? && answered.nil?) || ((! tags.blank?) && (tags.include? "Support") && answered.nil?)
        api = ping_api(callrail_id)
        tags = api["tags"]
        answered = api["answered"]
        puts "#{api}, #{counter}, #{answered}, #{tags}"
        counter +=1
        sleep 5
      else
        break
      end
    end

    if (! tags.blank?) &&(tags.include? "Support") && answered
      #do cti stuff
    end
  end
  
  def ping_api(callrail_id)
    CallrailApi.new(callrail_id).get_call
  end
end
