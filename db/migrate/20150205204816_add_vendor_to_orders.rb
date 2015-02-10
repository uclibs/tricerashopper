class AddVendorToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :vendor_code, :string
    add_column :orders, :vendor_note, :string
  end
end
