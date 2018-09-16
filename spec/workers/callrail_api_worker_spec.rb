require "rails_helper"

RSpec.describe CallrailApiWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
    stub_request(:get, "https://api.callrail.com/v2/a/266101466/calls/1234.json?fields=tags").
                with(:headers => { "Authorization" => "Token token=#{Rails.application.credentials.callrail_api_key}" }).
                to_return(status: 200, body: callrail_api_response.to_json, headers:{})
  end

  let(:callrail_id) { "1234" }
  let(:worker) { CallrailApiWorker.new }
  let(:callrail_api_response) {
    {
      "answered"=>nil,
      "business_phone_number"=>nil,
      "customer_city"=>"Atlanta",
      "customer_country"=>"US",
      "customer_name"=>"User",
      "customer_phone_number"=>"+15555555555",
      "customer_state"=>"GA",
      "direction"=>"inbound",
      "duration"=>8,
      "id"=>1234,
      "recording"=>nil,
      "recording_duration"=>nil,
      "recording_player"=>nil,
      "start_time"=>"2018-09-16T14:59:53.250-04:00",
      "tracking_phone_number"=>"+15555555555",
      "voicemail"=>false,
      "tags"=>[]
    }
  }

  it "should keep pinging the api when answered is nil" do
    allow(worker).to receive(:loop).and_yield.and_yield
    expect(worker).to receive(:sleep).with(5).twice
    worker.perform("1234")
  end
end