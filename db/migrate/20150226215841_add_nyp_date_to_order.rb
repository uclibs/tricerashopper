class AddNypDateToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :not_yet_published_date, :date
  end
end
