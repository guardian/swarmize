class CreateSwarmFields < ActiveRecord::Migration
  def change
    create_table :swarm_fields do |t|
      t.integer :field_index
      t.string :field_type
      t.string :field_name
      t.string :field_code
      t.text :hint
      t.string :sample_value
      t.boolean :compulsory, :default => false
      t.text :possible_values
      t.integer :minimum, :default => nil
      t.integer :maximum, :default => nil
      t.references :swarm
      t.timestamps
    end
  end
end
