class Zendesk::TicketsController < ApplicationController
  def new
    if params[:id].nil?
      @email = params[:email]
    else
      @id = params[:id]
      @name = params[:name]
      @email = params[:email]
    end
    @number = Call.order(:updated_at).where(:agent_email => current_user.email).last.formatted_caller_number
  end
end