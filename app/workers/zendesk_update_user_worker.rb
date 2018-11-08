require 'callrail_api'

class ZendeskUpdateUserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(zendesk_id, formatted_caller_number)
    user = Zendesk.client.users.find(:id => zendesk_id)
    user.phone = formatted_caller_number
    user.save
  end
end