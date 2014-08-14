class CreateGraphConfigurations < ActiveRecord::Migration
  def change
    create_table :graph_configurations do |t|
      t.string :title
      t.string :graph_type
      t.string :field
      t.string :viz_type
      t.text :options
      t.references :swarm
      t.timestamps
    end
  end
end
