class AddUserIdToSwarms < ActiveRecord::Migration
  def change
    add_column :swarms, :user_id, :integer
    add_index :swarms, :user_id
  end
end
