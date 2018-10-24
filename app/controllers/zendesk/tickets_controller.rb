class Zendesk::TicketsController < ApplicationController

  def new
    @id = params[:id]
    @name = params[:name]
    @email = params[:email]
    @number = Call.order(:updated_at).where(:agent_email => current_user.email).last.formatted_caller_number
  end

end