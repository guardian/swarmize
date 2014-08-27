class AddCreatorsToAccessPermissions < ActiveRecord::Migration
  def change
    add_column :access_permissions, :creator_id, :integer, :default => nil
  end
end
