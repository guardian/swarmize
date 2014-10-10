class RemoveVizType < ActiveRecord::Migration
  def up
    Graph.all.each do |graph|
      graph.graph_type = graph.viz_type
      graph.save
    end
    remove_column :graphs, :viz_type
  end

  def down
    add_column :graphs, :viz_type, :string
  end
end
