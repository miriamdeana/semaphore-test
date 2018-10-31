require 'rails_helper'

describe 'caller does not exist as a user in Zendesk' do
  before(:each) do
    stub_request(:get, %r{/api/v2/users/search}).
         to_return(status: 200, body: '', headers: {})
  end

  let(:user) { create(:user) }
  let(:call) { Call.create!(
    callrail_id: 1234,
    caller_number: '+15555555555',
    formatted_caller_number: '555-555-5555'
  )}

  context 'call comes in and is answered by the agent' do
    it 'does not allow agent to create new ticket', js: true do
      update_call
      expect(page).not_to have_content('create a new ticket')
    end
  end

  context 'agent searchs for caller by email', :aggregate_failures do
    it 'allows agent to create a new ticket if caller is not found', js: true do
      update_call
      page.fill_in('search', with: 'user@test.com')
      page.click_button('Lookup by Email')
      expect(page).to have_content('user@test.com')
      expect(page).to have_link('Create a new ticket', href: "/zendesk/tickets/new?email=user%40test.com")
    end
  end
end