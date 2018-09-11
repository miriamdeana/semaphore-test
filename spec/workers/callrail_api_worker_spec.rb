require "rails_helper"

RSpec.describe CallrailApiWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  let(:callrail_id) { 1234 }
  let(:api_response) { CallrailApi.new(callrail_id).get_call }

  describe "CallRail API Worker" do
    it "should create a job in the queue with a callrail_id" do
      expect {
        CallrailApiWorker.perform_async(callrail_id)    
      }.to change(CallrailApiWorker.jobs, :size).by(1)
    end

    it "should return json for a successful API ping with call_id" do
      expect(api_response.content_type).to eq "application/json"
    end
  end
end