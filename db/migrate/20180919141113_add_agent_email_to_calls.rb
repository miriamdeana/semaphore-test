class AddAgentEmailToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :agent_email, :string
  end
end
