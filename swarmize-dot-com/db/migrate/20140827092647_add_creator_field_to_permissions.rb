class AddCreatorFieldToPermissions < ActiveRecord::Migration
  def change
    add_column :access_permissions, :is_creator, :boolean, :default => false
  end
end
