class Zendesk::TicketsController < ApplicationController
  def new
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