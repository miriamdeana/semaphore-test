class AddSubmitterIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :submitter_id, :integer
    add_index :users, :submitter_id, unique: true
  end
end
