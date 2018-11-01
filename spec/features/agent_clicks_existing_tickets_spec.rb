require 'rails_helper'

 describe 'agent clicks existing ticket button', :aggregate_failures do
  let(:user) { create(:user) }
  it 'opens a new window leading to specified user\'s Zendesk ticket history', js:true do
    login_as user
    set_caller_number
    visit("/zendesk/tickets/new?email=support%2Bintegrationtest%40olark.com&id=360248023446&name=Olark&phone=5555555555%2C+4444444444")
    expect(page).to have_link('existing Zendesk tickets', href: %r[callrail1472494564.zendesk.com/agent/users/#{zendesk_user.id}/tickets])
    expect(page).not_to have_link('existing Zendesk tickets', href: %r[callrail1472494564.zendesk.com/agent/users/12345/tickets])
    expect(find_link('existing Zendesk tickets')[:target]).to eq('_blank')
  end
end