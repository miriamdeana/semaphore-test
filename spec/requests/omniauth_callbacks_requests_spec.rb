require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :request do


  describe "user login" do
    it "should successfully login a valid user" do
      post "/users/sign_in"
      expect(response).to have_http_status(200)
    end
  end

  describe "user logout" do
    it "should successfully logout and return to login page" do
      delete "/users/sign_out"
      expect(response).to redirect_to root_path
    end
  end
end