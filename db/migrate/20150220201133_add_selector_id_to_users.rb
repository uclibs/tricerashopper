class AddSelectorIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :selector_id, :integer
  end
end
