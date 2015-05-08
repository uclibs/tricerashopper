class RemoveRushProcessFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :rush_process, :boolean
  end
end
