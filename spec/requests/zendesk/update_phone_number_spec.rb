require 'rails_helper'

describe 'ZendeskUpdateUserWorker' do
  before(:each) do
    stub_request(:post, 'https://callrail1472494564.zendesk.com/api/v2/tickets').
         to_return(status: 200, body: '', headers: {})
    Sidekiq::Worker.clear_all
  end
  let(:params) {
    {
      'id' => id,
      'name' => 'Mr Customer',
      'email' => 'customer@example.com',
      'phone' => '555-555-5555',
      'subject'=> 'CTI Phone Call Ticket',
      'description' => 'This is a description.'
    }
  }

  context 'id exists' do
    let(:id) { 12345 }
    it 'should run ZendeskUpdateUserWorker' do
      expect { post '/zendesk/tickets/create', :params => params }.to change(ZendeskUpdateUserWorker.jobs, :size).by(1)
    end
  end

  context 'id does NOT exist' do
    let(:id) { nil }
    it 'should NOT run ZendeskUpdateUserWorker' do
      expect { post '/zendesk/tickets/create', :params => params }.to_not change(ZendeskUpdateUserWorker.jobs, :size)
    end
  end
end
