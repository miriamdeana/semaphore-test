require 'rails_helper'

RSpec.describe Call do
  before(:each) do
    stub_request(:get, "https://callrail1472494564.zendesk.com/api/v2/users/search?query=*#{call.formatted_caller_number}").
         to_return(status: 200, body: "", headers: {})
  end
  
  let(:user) { build(:user) }
  let!(:call) { Call.create!(
    callrail_id: 1234,
    caller_number: "+15555555555",
    formatted_caller_number: "555-555-5555",
    answered: answered,
    agent_email: agent_email
    )}

  describe 'after_commit' do
    context 'answered and agent_email start as nil' do
      let(:answered) { nil }
      let(:agent_email) { nil }

      it 'calls ActionCable.broadcast after update' do
        expect(ActionCable.server).to receive(:broadcast)
        call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      end

      it 'queries Zendesk API after update' do
        expect(Zendesk).to receive_message_chain("client.users.search") { [] }
        call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      end
    end

    context 'answered and agent_email do not start off as nil' do
      let(:answered) { "false" }
      let(:agent_email) { "user2@callrail.com" }
      let(:formatted_caller_number) { "555-555-5555" }

      it 'ActionCable does not broadcast to agent' do
        expect(ActionCable.server).not_to receive(:broadcast)
        call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      end
    end
  end
end