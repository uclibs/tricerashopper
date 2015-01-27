class AddLmloToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lmlo_receives_report, :boolean
  end
end
