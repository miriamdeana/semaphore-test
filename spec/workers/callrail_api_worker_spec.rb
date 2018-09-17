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
      "start_time"=>"2018-09-16T14:59:53.250-04:00",
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
      allow(worker).to receive(:loop).and_yield.and_yield
      expect(worker).to receive(:sleep).with(5).twice
      worker.perform("1234")
    end
  end

  context "call is not tagged Support" do
    let(:answered) { nil }
    let(:tags) { [{"name"=>"Sales"}] }

    it "should stop immediately" do
      worker.perform("1234")
    end
  end

  context "answered = nil and call is tagged Support" do
    let(:answered) { nil }
    let(:tags) { [{"name"=>"Support"}].to_json }

    it "should continue to ping the api" do
      allow(worker).to receive(:loop).and_yield.and_yield
      expect(worker).to receive(:sleep).with(5).twice
      worker.perform("1234")
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

    it "should stop immediately" do
      worker.perform("1234")
    end
  end
  
end