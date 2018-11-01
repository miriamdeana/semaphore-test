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
    name = params[:name]
    email = params[:email]
    phone = params[:phone]
    description = params[:description]

    @ticket = Zendesk.client.tickets.create(:subject => "CTI Phone Call Ticket",
      :requester => { :name => name, :email => email, :phone => phone }, :tags=> ["inboundcallticket"],
      :comment => { :value => description, :public => false },
      :submitter_id => 370404079212, :status => "open")
  end
end