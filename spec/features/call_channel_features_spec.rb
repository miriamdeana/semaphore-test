require 'rails_helper'

RSpec.describe CallChannel do
  let(:user) { create(:user) }
  let!(:call) { Call.create!(
    callrail_id: 1234,
    caller_number: "+15555555555",
    formatted_caller_number: "555-555-5555"
    )}

  context 'current user answers the call' do
    it 'changes the screen with caller\'s phone number', js: true do
      login_as user
      visit root_path
      call.update_attributes!(answered: "true", agent_email: "user@callrail.com")
      expect(page).to have_content(call.formatted_caller_number)
    end
  end

  context 'current user does not answer the call' do
    it 'does not change the screen with caller\'s phone number', js: true do
      login_as user
      visit root_path
      call.update_attributes!(answered: "true", agent_email: "another_user@callrail.com")
      expect(page).to_not have_content(call.formatted_caller_number)
    end
  end
end
  