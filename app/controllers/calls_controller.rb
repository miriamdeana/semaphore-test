require 'callrail_api'

class CallsController < ApplicationController
  protect_from_forgery with: :null_session
  def create
    call_id = params[:id]
    # calls_queue << call_id
    new_call = Call.create!(
       callrail_id: params[:id],
       start_time: params[:start_time],
       caller_number: params[:formatted_customer_phone_number]
     )
    api = CallrailApi.new(call_id).get_call
    Call.find_by(callrail_id: call_id).update(answered: api["answered"])
  end
end