class RenameGraphConfigurations < ActiveRecord::Migration
  def change
    rename_table :graph_configurations, :graphs
  end
end
