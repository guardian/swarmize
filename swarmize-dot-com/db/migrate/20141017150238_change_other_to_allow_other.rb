class ChangeOtherToAllowOther < ActiveRecord::Migration
  def change
    rename_column :swarm_fields, :other, :allow_other
  end
end
