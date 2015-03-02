class AddNypToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :not_yet_published, :boolean
  end
end
