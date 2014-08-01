class AddSpikedFieldToSwarms < ActiveRecord::Migration
  def change
    add_column :swarms, :is_spiked, :boolean, :default => false
  end
end
