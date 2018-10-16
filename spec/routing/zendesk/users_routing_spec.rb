require 'rails_helper'

RSpec.describe "routes for Zendesk/Users" do
  it "routes /zendesk/users/email_lookup to zendesk/users controller" do
    expect(:get => "/zendesk/users/email_lookup").
      to route_to(:controller => "zendesk/users", :action => "email_lookup")
  end

  it "is not a post route" do
    expect(:post => "/zendesk/users/email_lookup").not_to be_routable
  end
end