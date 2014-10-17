class AddTogglesToSwarm < ActiveRecord::Migration
  def change
    add_column :swarms, :display_title, :boolean, :default => true
    add_column :swarms, :display_description, :boolean, :default => true
  end
end
