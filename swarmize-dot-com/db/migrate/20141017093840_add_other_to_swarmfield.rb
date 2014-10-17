class AddOtherToSwarmfield < ActiveRecord::Migration
  def change
    add_column :swarm_fields, :other, :boolean, :default => false
  end
end
