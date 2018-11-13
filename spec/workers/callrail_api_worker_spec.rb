require 'rails_helper'

RSpec.describe CallrailApiWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
    stub_request(:get, "https://api.callrail.com/v2/a/266101466/calls/1234.json?fields=tags,agent_email").
                with(:headers => { "Authorization" => "Token token=#{Rails.application.credentials.callrail_api_key}" }).
                to_return(status: 200, body: '', headers:{})
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
      "tags"=> tags,
      "agent_email"=> agent_email
    }
  } 

  let(:worker) { CallrailApiWorker.new }
  let!(:call) { Call.create!(callrail_id: 1234) }
  let!(:user) { FactoryBot.create(:user) }

  def stub_worker
    allow(worker).to receive(:ping_api).and_return(subject)
  end

  context 'when answered = nil' do
    let(:answered) { nil }
    let(:agent_email) { nil }

    context 'with no tags' do
      let(:tags) { [] }
      
      it 'should continue to ping the api' do
        stub_worker
        expect(CallrailApiWorker).to receive(:perform_in).with(5.seconds, 1234)
        worker.perform(1234)
      end

      it 'should have answered and agent_email as nil in call model' do
        stub_worker
        worker.perform(1234)
        call.reload
        expect(call.answered).to eq(nil)
        expect(call.agent_email).to eq(nil)
      end
    end

    context 'call is not tagged Support' do
      let(:tags) { [{"name"=>"Sales"}] }

      it 'should stop and not call any more jobs' do
        stub_worker
        expect(CallrailApiWorker).to_not receive(:perform_in).with(5.seconds, 1234)
        worker.perform(1234)
      end
    end

    context 'call is tagged Support' do
      let(:tags) { [{"name"=>"Support"}] }

      it "should continue to ping the api" do
        stub_worker
        expect(CallrailApiWorker).to receive(:perform_in).with(5.seconds, 1234)
        worker.perform(1234)
      end
    end
  end

  context 'when answered = false' do
    let(:answered) { false }
    let(:tags) { [] }
    let(:agent_email) { nil }

    it 'should stop and not call any more jobs' do
      stub_worker
      expect(CallrailApiWorker).to_not receive(:perform_in).with(5.seconds, 1234)
      worker.perform(1234)
    end

    it 'should have answered and agent_email as nil in call model' do
      stub_worker
      worker.perform(1234)
      call.reload
      expect(call.answered).to eq(nil)
      expect(call.agent_email).to eq(nil)
    end
  end

  context 'answered = true and call is tagged Support' do
    let(:answered) { true }
    let(:tags) { [{"name"=>"Support"}] }
    let(:agent_email) { "user@callrail.com" }

    it 'should save the agent_email and change answered status in call model' do
      stub_worker
      worker.perform(1234)
      call.reload
      expect(call.answered).to eq("true")
      expect(call.agent_email).to eq("user@callrail.com")
    end
  end

  context 'first call answered by agent' do
    let(:answered) { true }
    let(:tags) { [{"name"=>"Support"}] }
    let(:agent_email) { "user@callrail.com" }

    it 'should call ZendeskAgentWorker when submitter_id is nil' do
      stub_worker
      expect { worker.perform(1234) }.to change(ZendeskAgentWorker.jobs, :size).by(1)
    end
  end
end