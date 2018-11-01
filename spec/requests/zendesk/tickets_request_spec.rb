require 'rails_helper'

describe 'Tickets' do
  before(:each) do
    stub_request(:post, "https://callrail1472494564.zendesk.com/api/v2/tickets").
    to_return(status: 200, body: "", headers: {})
  end

  let(:create_ticket) { post zendesk_tickets_create_url,
    :params => {
      :subject => 'Phone Call Ticket',
      :submitter_id => 370404079212,
      :tags => ['inboundcallticket'],
      :comment => { :value => 'Description of call.', :public => false },
      :requester => { :name => "Mr Customer",
                      :email => "customer@example.com",
                      :phone => '555-555-5555'
                    }
    }
  }

  describe 'Ticket Creation' do
    it 'should initiate a post request to Zendesk' do
      create_ticket
      body = '{"ticket":{"subject":"CTI Phone Call Ticket","requester":{"name": "Mr Customer","email": "customer@example.com","phone": "555-555-5555"},"tags":["inboundcallticket"],"comment":{"value": "This is the description","public":false},"submitter_id":370404079212,"status":"open"}}'
      expect(a_request(:post, "https://callrail1472494564.zendesk.com/api/v2/tickets").
      with { |req| req.body == body }).
      to have_been_made
    end
  end
end