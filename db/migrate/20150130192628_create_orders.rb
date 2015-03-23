class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :title
      t.string :author
      t.string :format
      t.string :publication_date
      t.string :isbn
      t.string :publisher
      t.integer :oclc
      t.string :edition
      t.string :selector
      t.string :requestor
      t.string :location_code
      t.string :fund
      t.integer :cost
      t.boolean :added_edition
      t.boolean :added_copy
      t.string :added_copy_call_number
      t.boolean :rush_order
      t.boolean :rush_process
      t.boolean :notify
      t.boolean :reserve
      t.string :notification_contact
      t.string :relevant_url
      t.string :other_notes
      t.string :workflow_state
      t.string :vendor_address
      t.boolean :credit_card_order

      t.timestamps
    end
  end
end
