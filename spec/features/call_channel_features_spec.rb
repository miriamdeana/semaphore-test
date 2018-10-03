require 'rails_helper'

RSpec.describe CallChannel do
  before(:each) do
    stub_request(:get, "https://callrail1472494564.zendesk.com/api/v2/users/search?query=*555-555-5555").
         to_return(status: 200, body: "", headers: {})
  end

  let(:user) { create(:user) }
  let!(:call) { Call.create!(
    callrail_id: 1234,
    caller_number: "+15555555555",
    formatted_caller_number: "555-555-5555"
    )}

  context 'current user answers the call' do
    it 'changes the screen', js: true do
      login_as user
      visit root_path
      call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      expect(page).to_not have_content("Hello, #{user.first_name}!")
    end
  end

  context 'current user does not answer the call' do
    it 'does not change the screen', js: true do
      login_as user
      visit root_path
      call.update_attributes!(answered: "true", agent_email: "another_user@callrail.com")
      expect(page).to have_content("Hello, #{user.first_name}!")
    end
  end
end
  