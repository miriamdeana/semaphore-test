class Zendesk::TicketsController < ApplicationController
  def new
  end

  def create
    @ticket = Zendesk.client.tickets.create(:subject => "Phone Call Ticket", :tags=> ["inboundcallticket"],
      :comment => { :value => "This is a description of the issue.", :public => false },
      :requester_id => 370404079212, :submitter_id => 370404079212, :status => "open")
  end
end