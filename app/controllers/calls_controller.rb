class CallsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    @call = Call.create!(
       callrail_id: params[:id],
       start_time: params[:start_time],
       caller_number: params[:customer_phone_number],
       formatted_caller_number: params[:formatted_customer_phone_number]
     )
    
     CallrailApiWorker.perform_async(@call.callrail_id) if @call.save
  end
end
