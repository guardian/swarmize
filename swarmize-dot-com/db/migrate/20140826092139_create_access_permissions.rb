class CreateAccessPermissions < ActiveRecord::Migration
  def change
    create_table :access_permissions do |t|
      t.references :swarm
      t.references :user
      t.string :email
      t.timestamps
    end

    add_index :access_permissions, :email
  end
end
