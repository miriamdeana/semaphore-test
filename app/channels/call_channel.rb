class CallChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user.email
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
