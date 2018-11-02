class AgentChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user.email
  end

  def unsubscribed
  end
end