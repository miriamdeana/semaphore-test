module CallHelper
  def update_call
    login_as user
    visit root_path
    page.find('.callChannelConnect')
    call.update_attributes!(answered: 'true', agent_email: 'user@callrail.com')
  end
end

RSpec.configure do |config|
  config.include CallHelper, type: :feature
end