class Call < ApplicationRecord
  after_commit on: :update do
    if call_answered_by_agent? && first_update?
      data = "call from #{formatted_caller_number}"
      ActionCable.server.broadcast "call:#{agent_email}", data
    end
  end

  def call_answered_by_agent?
    answered == "true" && agent_email.present?
  end

  def first_update?
    answered_before_last_save == nil && agent_email_before_last_save == nil
  end
end
