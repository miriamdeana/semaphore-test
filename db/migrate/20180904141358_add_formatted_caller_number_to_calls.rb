class AddFormattedCallerNumberToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :formatted_caller_number, :string
  end
end
