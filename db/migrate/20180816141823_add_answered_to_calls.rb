class AddAnsweredToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :answered, :string
  end
end
