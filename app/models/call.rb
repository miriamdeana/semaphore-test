class Call < ApplicationRecord
  after_commit on: :update do
    if call_answered_by_agent? && first_update?
      ActionCable.server.broadcast "call:#{agent_email}", known_users: render_known_users(formatted_caller_number, zendesk_users_data)
    end
  end

  def call_answered_by_agent?
    answered == "true" && agent_email.present?
  end

  def first_update?
    answered_before_last_save == nil && agent_email_before_last_save == nil
  end

  private
  def zendesk_users_data
    find_by_phone = Zendesk.client.users.search(:query => "*#{formatted_caller_number}")
    return find_by_phone.map do |i|
      {
        "name" => i["name"],
        "email" => i["email"]
      }
    end
  end

  def render_known_users(formatted_caller_number, names_found)
    ApplicationController.render(
      partial: 'zendesk/users_show',
      locals: { 
        names_found: names_found,
        formatted_caller_number: formatted_caller_number
      }
    )
  end
end