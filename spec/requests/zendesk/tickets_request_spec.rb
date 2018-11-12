require 'rails_helper'

describe 'Tickets' do
  describe 'Ticket Creation' do
    it 'should initiate a post request to Zendesk' do
      form_params = {
        'name' => 'Mr Customer',
        'email' => 'customer@example.com',
        'phone' => '555-555-5555',
        'subject'=> 'CTI Phone Call Ticket',
        'description' => 'This is a description.'
      }

      zendesk_params = {
        :subject => "CTI Phone Call Ticket",
        :requester => { :name => form_params['name'], :email => form_params['email'],
        :phone => form_params['phone'] }, :tags=> ["inboundcallticket"],
        :comment => { :value => form_params['description'], :public => false },
        :submitter_id => 370404079212, :status => "open"
      }

      expect(Zendesk).to receive_message_chain(:client, :tickets, :create).with(zendesk_params)
      post zendesk_tickets_create_path(form_params)
    end
  end
end