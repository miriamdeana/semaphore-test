require 'rails_helper'

RSpec.describe Zendesk::UsersController, :aggregate_failures do

  let(:user) { create(:user) }
  context 'agent clicks on a user\'s name' do
    it 'leads to new ticket form with relevant user information', js: true do
      login_as user
      zendesk_user = OpenStruct.new(:id => 360248023446, :name => 'Olark', :email => 'sample@gmail.com', :phone => '555-555-5555')
      zendesk_users_array = [zendesk_user]
      allow_any_instance_of(Zendesk::UsersController).to receive(:list_phone_numbers).and_return('555-555-5555')
      allow(Zendesk).to receive_message_chain(:client, :users, :search).and_return(zendesk_users_array)
      allow_any_instance_of(Zendesk::TicketsController).to receive(:current_user).and_return(user)
      allow(Call).to receive_message_chain(:order, :where, :last, :formatted_caller_number).and_return('555-555-5555')

      visit('/zendesk/users/search_results?search=*555-555-5555')
      expect(page).to have_content('Olark')
      click_on 'Olark'
      expect(page).to have_content('555-555-5555')
      expect(page).to have_content(zendesk_user.name)
      expect(page).to have_content(zendesk_user.email)
      expect(page).to have_field('subject')
      expect(page).to have_field('description')
      expect(page).to have_button('Create New Ticket')
    end
  end
end