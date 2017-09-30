class AddVendorToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :vendor_code, :string
    add_column :orders, :vendor_note, :string
  end
end
