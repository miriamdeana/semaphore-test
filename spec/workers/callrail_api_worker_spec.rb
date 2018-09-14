require "rails_helper"

RSpec.describe CallrailApiWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
    stub_request(:get, "https://api.callrail.com/v2/a/266101466/calls/1234.json?fields=tags").
                with(:body => callrail_api_response,
                      :headers => { "Authorization" => "Token token=#{Rails.application.credentials.callrail_api_key}" })
  end

  let(:callrail_id) { "1234" }
  let(:worker) { CallrailApiWorker.new }
  let(:callrail_api_response) {
    { 
      "answered": false
    }
  }

  it "should" do
    allow(worker).to receive(:ping_api).and_return(callrail_api_response)
    # expect(worker).to receive(:ping_api).and_return(callrail_api_response)
    # Sidekiq::Testing.inline! do
      worker.perform("1234")
      # assert_equal 1, CallrailApiWorker.jobs.size
      # CallrailApiWorker.drain
      # assert_equal 0, CallrailApiWorker.jobs.size
    # end
  end
end