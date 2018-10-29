require 'rails_helper'

describe 'Tickets' do
  let(:create_ticket) { post zendesk_tickets_create_url, 
    :params => {
      :subject => 'Phone Call Ticket',
      :comment => { :value => 'Description of call.' },
      :requester_id => 370404079212,
      :submitter_id => 370404079212
    }
  }
  before(:each) do 
    stub_request(:post, "https://callrail1472494564.zendesk.com/api/v2/tickets").
    to_return(status: 200, body: '', headers: {})
  end

  describe 'Ticket Creation' do 
    it 'should make a Zendesk post request' do
      create_ticket
      expect(Zendesk).to  receive_message_chain(:client, :tickets, :create)
    end
  

    # it 'should' do
    # #Lookup how to test that a stub request has been called
    # # Make sure that the Zendesk api post request happens wehen you hit the zendesk/tickets/create endpoint
    # end
  end
end