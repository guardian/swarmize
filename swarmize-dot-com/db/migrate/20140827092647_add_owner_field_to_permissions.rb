class AddOwnerFieldToPermissions < ActiveRecord::Migration
  def change
    add_column :access_permissions, :is_owner, :boolean, :default => false
  end
end
