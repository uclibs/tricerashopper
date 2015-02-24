class AddSelectorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :selector_id, :integer
  end
end
