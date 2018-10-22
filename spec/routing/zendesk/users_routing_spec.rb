require 'rails_helper'

RSpec.describe "routes for Zendesk/Users" do
  it "routes /zendesk/users/search_results to zendesk/users controller" do
    expect(:get => "/zendesk/users/search_results").
      to route_to(:controller => "zendesk/users", :action => "search_results")
  end

  it "is not a post route" do
    expect(:post => "/zendesk/users/search_results").not_to be_routable
  end
end