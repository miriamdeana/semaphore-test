class CallsController < ApplicationController
  # protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  
  def create
    call_id = params[:id]
    new_call = Call.create!(
       callrail_id: params[:id],
       start_time: params[:start_time],
       caller_number: params[:formatted_customer_phone_number]
     )
    api = CallrailApi.new(call_id).get_call
    Call.find_by(callrail_id: call_id).update(answered: api["customer_city"])
  end
end