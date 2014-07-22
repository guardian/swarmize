class AddOpenCloseToSwarm < ActiveRecord::Migration
  def change
    add_column :swarms, :opens_at, :datetime
    add_column :swarms, :closes_at, :datetime
  end
end
