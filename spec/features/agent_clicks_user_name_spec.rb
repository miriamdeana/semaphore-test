require 'rails_helper'

 describe 'agent clicks on a user\'s name', :aggregate_failures do
  let(:user) { create(:user) }
  it 'leads to new ticket form for existing user with relevant user information', js: true do
    login_as user
    get_search_results
    set_caller_number
    visit('/zendesk/users/search_results?search=*555-555-5555')
    expect(page).to have_content('Olark')
    click_on 'Olark'
    expect(page).to have_field('name', with: zendesk_user.name, readonly: true)
    expect(page).to have_field('email', with: zendesk_user.email, readonly: true)
    expect(page).to have_field('phone', with: '555-555-5555', readonly: true)
    expect(page).to have_field('subject', with: 'Phone Call Ticket', readonly: true)
    expect(page).to have_field('description')
    expect(page).to have_link('existing Zendesk tickets')
    expect(page).to have_button('Create New Ticket')
  end
end