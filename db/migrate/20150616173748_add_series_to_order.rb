class AddSeriesToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :series, :text
  end
end
