require "rails_helper"

RSpec.describe CallrailApiWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
    stub_request(:get, "https://api.callrail.com/v2/a/266101466/calls/1234.json?fields=tags").
                with(:headers => { "Authorization" => "Token token=#{Rails.application.credentials.callrail_api_key}" }).
                to_return(status: 200, body: subject.to_json, headers:{})
  end 

  subject {
    {
      "answered"=> answered,
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
      "start_time"=>Time.now,
      "tracking_phone_number"=>"+15555555555",
      "voicemail"=>false,
      "tags"=> tags
    }
  }
  let(:worker) { CallrailApiWorker.new }

  context "answered = nil and tags []" do
    let(:answered) { nil }
    let(:tags) { [] }
    
    it "should continue to ping the api" do
      allow(worker).to receive(:ping_api).and_return(subject)
      expect(CallrailApiWorker).to receive(:perform_in).with(5.seconds, 1234)
      worker.perform(1234)
    end
  end

  context "call is not tagged Support" do
    let(:answered) { nil }
    let(:tags) { [{"name"=>"Sales"}].to_json }

    it "should stop and not call any more jobs" do
      CallrailApiWorker.perform_async("1234")
      assert_equal 1, CallrailApiWorker.jobs.size
      CallrailApiWorker.drain
      assert_equal 0, CallrailApiWorker.jobs.size
    end
  end

  context "answered = nil and call is tagged Support" do
    let(:answered) { nil }
    let(:tags) { [{"name"=>"Support"}].to_json }

    it "should continue to ping the api" do
      allow(worker).to receive(:ping_api).and_return(subject)
      expect(CallrailApiWorker).to receive(:perform_in).with(5.seconds, 1234)
      worker.perform(1234)
    end
  end

  # context "answered = true and call is tagged Support" do
  #   let(:answered) { true }
  #   let(:tags) { [{"name"=>"Support"}] }

  #   it "should do CTI stuff" do
  #     #stuff goes here
  #   end
  # end

  context "answered = false" do
    let(:answered) { false }
    let(:tags) { [] }

    it "should stop and not call any more jobs" do
      CallrailApiWorker.perform_async("1234")
      assert_equal 1, CallrailApiWorker.jobs.size
      CallrailApiWorker.drain
      assert_equal 0, CallrailApiWorker.jobs.size
    end
  end
  
end