class AddNypDateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :not_yet_published_date, :date
  end
end
