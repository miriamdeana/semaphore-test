require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :feature do

  let(:user) { create(:user) }

  describe "user login" do
    it "valid login is successful" do
      stub_omniauth
      visit root_path
      click_link "google-oauth2-login"
      expect(page).to have_http_status(:success)
    end


    it "shows user to welcome page on valid login" do
      stub_omniauth
      visit root_path
      click_link "google-oauth2-login"
      expect(page).to have_content("Hello, #{user.first_name}!")
      expect(page).to have_link("Logout")
    end

    it "shows failed flash message when email is invalid" do
      mock_invalid_email_auth
      visit root_path
      click_link "google-oauth2-login"
      expect(page).to have_content("Email is invalid")
    end
  end

  describe "user logout" do
    it "shows a success flash message when logging out" do
      login_as user
      visit root_path
      click_link "Logout"
      expect(page).to have_http_status(:success)
      expect(page).to have_content("Signed out successfully.")
    end
  end
end

# Does the controller redirect to the expected view or render the expected template?
# Does the controller give the appropriate http response code?
# What type of content should we respond with?
# Does the controller need to render flash messages?
# Was any information added/updated/deleted? 