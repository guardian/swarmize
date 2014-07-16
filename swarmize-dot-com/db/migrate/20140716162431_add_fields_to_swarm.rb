class AddFieldsToSwarm < ActiveRecord::Migration
  def change
    add_column :swarms, :fields, :text
  end
end
