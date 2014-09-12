class AddDeletedAtToSwarms < ActiveRecord::Migration
  def up
    add_column :swarms, :deleted_at, :datetime
    add_index :swarms, :deleted_at
    Swarm.where(is_spiked: true).each do |swarm|
      swarm.update(deleted_at: Time.now)
    end
    remove_column :swarms, :is_spiked
  end

  def down
    add_column :swarms, :is_spiked, :boolean
    Swarm.only_deleted.each do |swarm|
      swarm.update(is_spiked: true)
    end
    remove_index :swarms, :deleted_at
    remove_column :swarms, :deleted_at
  end
end
