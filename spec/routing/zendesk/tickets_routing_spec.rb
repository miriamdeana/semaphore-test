require 'rails_helper'

RSpec.describe "routes for Zendesk/Tickets" do
  context "#new" do
    it "routes #new to zendesk/tickets controller" do
      expect(:get => "/zendesk/tickets/new").
        to route_to(:controller => "zendesk/tickets", :action => "new")
    end

    it "is not a post route" do
      expect(:post => "/zendesk/tickets/new").not_to be_routable
    end
  end

  context "#create" do
    it "routes #create to zendesk/tickets controller" do
      expect(:post => "/zendesk/tickets/create").
        to route_to(:controller => "zendesk/tickets", :action => "create")
    end

    it "is not a get route" do
      expect(:get => "/zendesk/tickets/create").not_to be_routable
    end
  end
end