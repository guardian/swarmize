class AddParentSwarmIdToSwarms < ActiveRecord::Migration
  def change
    add_column :swarms, :cloned_from, :integer, :default => nil
  end
end
