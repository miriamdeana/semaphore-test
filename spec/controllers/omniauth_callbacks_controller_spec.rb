require "rails_helper"

RSpec.feature "user logs in" do
  scenario "using google oauth 2" do
    stub_omniauth
    visit root_path
    expect(page).to have_link("google-oauth2-login")
    click_link "google-oauth2-login"
    expect(page).to have_content("Hello, Vicky!")
    expect(page).to have_link("Logout")
  end
end