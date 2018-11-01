require 'rails_helper'

 describe 'agent clicks on Create a new ticket link', :aggregate_failures do
  before(:each) do
    stub_request(:get, %r{/api/v2/users/search}).
         to_return(status: 200, body: '', headers: {})
  end

  let(:user) { create (:user) }

  it 'leads to new ticket form for new user with relevant user information', js: true do
    email =' test@example.com'

    login_as user
    set_caller_number
    visit("/zendesk/users/search_results?utf8=✓&email_searched=submitted&search=#{email}")
    expect(page).to have_link('Create a new ticket')
    click_on('Create a new ticket')
    expect(page).to have_field('name', with: '', readonly: false)
    expect(page).to have_field('email', with: email, readonly: false)
    expect(page).to have_field('phone', with: '555-555-5555', readonly: false)
    expect(page).to have_field('subject', with: 'Phone Call Ticket', readonly: true)
    expect(page).to have_field('description')
    expect(page).not_to have_link('existing Zendesk tickets')
    expect(page).to have_button('Create New Ticket')
  end
end