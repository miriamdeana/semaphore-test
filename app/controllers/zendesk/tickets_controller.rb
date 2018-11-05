class Zendesk::TicketsController < ApplicationController
  def new
    if params[:id]
      @partial = 'existing_user_new'
      @id = params[:id]
      @name = params[:name]
    else
      @partial = 'new_user_new'
    end

    @email = params[:email]
    @number = Call.order(:updated_at).where(:agent_email => current_user.email).last.formatted_caller_number
  end
end