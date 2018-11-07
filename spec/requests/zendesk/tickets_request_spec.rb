require 'rails_helper'

describe 'Tickets' do
  before(:each) do
    stub_request(:post, "https://callrail1472494564.zendesk.com/api/v2/tickets").
    to_return(status: 200, body: "", headers: {})
  end

  describe 'Ticket Creation' do
    it 'should initiate a post request to Zendesk' do
      params = {
        'name' => 'Mr Customer',
        'email' => 'customer@example.com',
        'phone' => '555-555-5555',
        'subject'=> 'CTI Phone Call Ticket',
        'description' => 'This is a description.'
      }
      post zendesk_tickets_create_path(params)
      request_body = {'ticket':{'subject': 'CTI Phone Call Ticket', 'requester': {'name': 'Mr Customer', 'email': 'customer@example.com', 'phone': '555-555-5555'}, 'tags':['inboundcallticket'], 'comment': {'value': 'This is the description', 'public': false }, 'submitter_id': 370404079212, 'status': 'open'}}
      expect(a_request(:post, 'https://callrail1472494564.zendesk.com/api/v2/tickets').
      with { |req| req.body == request_body }).
      to have_been_made
    end
  end
end