class CreateCalls < ActiveRecord::Migration[5.2]
  def change
    create_table :calls do |t|
      t.integer :callrail_id
      t.datetime :start_time
      t.string :caller_number

      t.timestamps
    end
  end
end
