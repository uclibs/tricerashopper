class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.text :title
      t.text :author
      t.text :format
      t.text :publication_date
      t.text :isbn
      t.text :publisher
      t.column :oclc, 'bigint'
      t.text :edition
      t.text :selector
      t.text :requestor
      t.text :location_code
      t.text :fund
      t.integer :cost
      t.boolean :added_edition
      t.boolean :added_copy
      t.text :added_copy_call_number
      t.boolean :rush_order
      t.boolean :rush_process
      t.boolean :notify
      t.boolean :reserve
      t.text :notification_contact
      t.text :relevant_url
      t.text :other_notes
      t.text :workflow_state
      t.text :vendor_address
      t.boolean :credit_card_order

      t.timestamps
    end
  end
end
