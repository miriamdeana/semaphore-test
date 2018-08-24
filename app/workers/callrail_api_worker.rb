class CallrailApiWorker
    include Sidekiq::Worker
    sidekiq_options retry: false



    def perform(callrail_id)
        puts "The callrail call id is #{callrail_id}"
    end

end
