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

  def create
    @ticket = Zendesk.client.tickets.create(:subject => "Phone Call Ticket", :tags=> ["inboundcallticket"],
      :comment => { :value => "This is a description of the issue.", :public => false },
      :requester_id => 370404079212, :submitter_id => 370404079212, :status => "open")
  end
end