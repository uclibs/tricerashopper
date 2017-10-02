class RemoveRushProcessFromOrder < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :rush_process, :boolean
  end
end
