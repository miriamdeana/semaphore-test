def stub_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      :provider => "google_oauth2",
      :uid => "123456789",
      :info => {
        :first_name => "Melissa",
        :last_name => "Kerns",
        :email => "user2@callrail.com"
      },
      :credentials => {
        :token => "token",
        :refresh_token => "refresh token"
      }
    }
  )
end

def mock_invalid_email_auth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      :provider => "google_oauth2",
      :uid => "987654321",
      :info => {
        :first_name => "Invalid",
        :last_name => "User",
        :email => "user@gmail.com"
      },
      :credentials => {
        :token => "secret",
        :refresh_token => "secret-token"
      }
    }
  )
end