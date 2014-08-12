class AddTokensToSwarms < ActiveRecord::Migration
  def change
    add_column :swarms, :token, :string, :limit => 8
  end
end
