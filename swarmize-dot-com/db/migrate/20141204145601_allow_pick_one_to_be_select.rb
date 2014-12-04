class AllowPickOneToBeSelect < ActiveRecord::Migration
  def change
    add_column :swarm_fields, :display_as_select, :boolean, default: false
  end
end
