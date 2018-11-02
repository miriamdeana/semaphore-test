require 'rails_helper'

describe 'ZendeskAgentWorker' do
  it 'receives an agent and updates the agent\'s submitter_id' do
    agent = create(:user)
    worker = ZendeskAgentWorker.new
    zendesk_agent = OpenStruct.new(
      :id => 12345,
      :name => 'Support Agent',
      :email => 'user@callrail.com'
    )
    allow(Zendesk).to receive_message_chain(:client, :users, :search, :fetch, :first).and_return(zendesk_agent)
    expect { worker.perform(agent.email) }.to change { agent.reload.submitter_id }.from(nil).to(zendesk_agent.id)
  end

  it 'receives an agent that is NOT a zendesk user' do
    agent = build(:user)
    worker = ZendeskAgentWorker.new
    allow(Zendesk).to receive_message_chain(:client, :users, :search, :fetch, :first, :id).and_return(nil)
    expect(ActionCable.server).to receive(:broadcast)
    worker.perform(agent.email)
  end
end