class CreateLostMissingLongOverdues < ActiveRecord::Migration
  def change
    create_table :lost_missing_long_overdues do |t|
      t.integer :item_number
      t.integer :bib_number
      t.string :title
      t.string :imprint
      t.string :isbn
      t.string :status
      t.integer :checkouts
      t.string :location
      t.text :note
      t.string :call_number
      t.string :volume
      t.string :barcode
      t.date :due_date
      t.date :last_checkout

      t.timestamps
    end
  end
end
