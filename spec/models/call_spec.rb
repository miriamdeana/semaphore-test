require 'rails_helper'

RSpec.describe Call do
  let(:user) { build(:user) }
  let!(:call) { Call.create!(
    callrail_id: 1234,
    caller_number: "+15555555555",
    formatted_caller_number: "555-555-5555",
    answered: answered,
    agent_email: agent_email
    )}

  describe 'ActionCable' do
    context 'answered and agent_email start as nil' do
      let(:answered) { nil }
      let(:agent_email) { nil }
      it 'sends a broadcast when answered and agent_email are updated from nil' do
        expect(ActionCable.server).to receive(:broadcast)
        call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      end
    end

    context 'answered and agent_email do not start off as nil' do
      let(:answered) { "false" }
      let(:agent_email) { "user2@callrail.com" }
      it 'does not send broadcast if answered and agent email were not nil before update' do
        expect(ActionCable.server).not_to receive(:broadcast)
        call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      end
    end
  end

end