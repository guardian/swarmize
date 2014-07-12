class CreateSwarms < ActiveRecord::Migration
  def change
    create_table :swarms do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
