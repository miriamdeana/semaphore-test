module ZendeskHelper
  def zendesk_user
    OpenStruct.new(:id => 360248023446, :name => 'Olark', :email => 'sample@gmail.com', :phone => '555-555-5555')
  end

  def get_search_results
    zendesk_users_array = [zendesk_user]
    allow_any_instance_of(Zendesk::UsersController).to receive(:list_phone_numbers).and_return('555-555-5555')
    allow(Zendesk).to receive_message_chain(:client, :users, :search).and_return(zendesk_users_array)
  end

  def set_caller_number
    allow_any_instance_of(Zendesk::TicketsController).to receive(:current_user).and_return(user)
    allow(Call).to receive_message_chain(:order, :where, :last, :formatted_caller_number).and_return('555-555-5555')
  end
end

RSpec.configure do |config|
  config.include ZendeskHelper, type: :feature
end