class AddNypToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :not_yet_published, :boolean
  end
end
