require 'rails_helper'

 describe 'zendesk searches for agent by email' do
  let(:user) { create(:user) }
  let(:worker) { ZendeskAgentWorker.new }
  before(:each) do
    Sidekiq::Worker.clear_all
    login_as user
    visit root_path
  end

  context 'zendesk DOES find agent and returns appropriate id', :aggregate_failures do
    it 'will not show the agent a flash message', js: true do
      zendesk_agent = OpenStruct.new(
        :id => 12345,
        :name => 'Support Agent',
        :email => 'user@callrail.com'
      )
      allow(Zendesk).to receive_message_chain(:client, :users, :search, :fetch, :first).and_return(zendesk_agent)
      worker.perform(user.email)
      expect(page).to_not have_content('We were unable to find you in Zendesk!')
    end
  end

  context 'zendesk DOES NOT find agent and returns nil', :aggregate_failures do
    it 'will let the agent know with a flash message', js: true do
      allow(Zendesk).to receive_message_chain(:client, :users, :search, :fetch, :first, :id).and_return(nil)
      worker.perform(user.email)
      page.find('.agentChannelConnect')
      expect(page).to have_selector('.alert-danger')
      expect(page).to have_content('We were unable to find you in Zendesk!')
    end
  end
end