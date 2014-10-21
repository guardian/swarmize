class ChangeDesscriptionToTextField < ActiveRecord::Migration
  def up
    change_column :swarms, :description, :text
  end
  def down
    change_column :swarms, :description, :string
  end
end
