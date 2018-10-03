require 'rails_helper'

RSpec.describe CallChannel do
  before(:each) do
    stub_request(:get, "https://callrail1472494564.zendesk.com/api/v2/users/search?query=*555-555-5555").
         to_return(status: 200, body: "", headers: {})
  end

  let(:user) { build(:user) }
  let!(:call) { Call.create!(
    callrail_id: 1234,
    caller_number: "+15555555555",
    formatted_caller_number: "555-555-5555"
    )}

  context 'current user answers the call' do
    let(:agent_email) { "user@callrail.com" }

    it 'broadcasts to the user\'s channel' do
      expect {
        ActionCable.server.broadcast(
          "call:#{agent_email}", data: "incoming call" 
        )      
        }.to have_broadcasted_to("call:#{user.email}")
    end
  end
end