class AddLmloToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :lmlo_receives_report, :boolean
  end
end
