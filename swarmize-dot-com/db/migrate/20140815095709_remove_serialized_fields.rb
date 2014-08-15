class RemoveSerializedFields < ActiveRecord::Migration
  def change
    remove_column :swarms, :fields, :text
  end
end
