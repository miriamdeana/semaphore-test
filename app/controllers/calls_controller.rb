class CallsController < ApplicationController
  protect_from_forgery with: :null_session
  def create
    Call.create!(
      callrail_id: params[:id],
      start_time: params[:start_time],
      caller_number: params[:formatted_customer_phone_number]
      )
  end
end