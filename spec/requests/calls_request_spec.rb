require 'rails_helper'

RSpec.describe CallsController, type: :request do

  let(:ping_webhook) { post "/calls", :params => { :callrail_id => "1234" } }

  describe 'CallRail webhook' do
    it 'should receive a webhook successfully' do
      ping_webhook
      expect(response).to have_http_status(200)
    end

    it 'should save new call to the database' do
      expect { ping_webhook }.to change{ Call.count }
    end
  end
end