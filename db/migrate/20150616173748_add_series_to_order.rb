class AddSeriesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :series, :text
  end
end
