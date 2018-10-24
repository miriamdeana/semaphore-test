require 'rails_helper'

RSpec.describe "routes for Zendesk/Tickets" do
  
  it "routes /zendesk/tickets/new to zendesk/tickets controller" do
    expect(:get => "/zendesk/tickets/new").
      to route_to(:controller => "zendesk/tickets", :action => "new")
  end

  it "is not a post route" do
    expect(:post => "/zendesk/tickets/new").not_to be_routable
  end
end