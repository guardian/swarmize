class AddIsFakeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_fake, :boolean, :default => false
  end
end
