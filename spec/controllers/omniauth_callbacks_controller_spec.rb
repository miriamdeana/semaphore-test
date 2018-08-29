require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do

# Does the controller redirect to the expected view or render the expected template?
    describe 'redirects to the expected views' do

        let(:user) { FactoryBot.create(:user) }

        context 'when logging in' do

            it 'redirects to welcome#home' do
                # sign in user and be sure that it redirects to the welcome page
                get user_google_oauth2_omniauth_authorize_path
                expect(response).to redirect_to(home_welcome_path)
                # maybe check for content of the page? page_should_contain("Hello #{user.name}")
            end
        end

        context 'when logging out' do
            # test what happens when a user logs out
        end

    end

# Does the controller give the appropriate http response code?
    # expect response code to equal 200
    # expect invalid login response to equal 302

# What type of content should we respond with?


# Does the controller need to render flash messages?
    # expect :flash to eq "flash message"

# Was any information added/updated/deleted? 
    # check user count increased by 1 when creating a user


end