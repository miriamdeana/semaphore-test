require 'rails_helper'

describe 'ZendeskUpdateUserWorker' do
  it 'should use Zendesk API client to update caller number' do
    zendesk_user = double('zendesk_user')
    formatted_caller_number = '123-456-7890'
    id = 12345
    expect(Zendesk).to receive_message_chain(:client, :users, :find).with(:id => id).and_return(zendesk_user)
    expect(zendesk_user).to receive(:phone=).with(formatted_caller_number)
    expect(zendesk_user).to receive(:save)
    ZendeskUpdateUserWorker.new.perform(id, formatted_caller_number)
  end
end
