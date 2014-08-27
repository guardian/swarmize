class RemoveCreatorFieldFromSwarm < ActiveRecord::Migration
  def change
    remove_column :swarms, :user_id, :integer
  end
end
