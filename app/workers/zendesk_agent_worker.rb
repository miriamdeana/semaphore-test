class ZendeskAgentWorker
  include Sidekiq::Worker

  def perform(agent_email)
    zendesk_agent = Zendesk.client.users.search(:query => agent_email).fetch.first

    if zendesk_agent.id
      agent = User.find_by(email: agent_email)
      agent.update_attributes!(submitter_id: zendesk_agent.id)
    else
      ActionCable.server.broadcast "agent:#{agent_email}",
      message: 'We were unable to find you in Zendesk! Tickets you create won\'t be associated with you. You should check with your manager about this issue.'
    end
  end
end