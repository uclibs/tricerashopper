class CreateLosts < ActiveRecord::Migration[5.0]
  def change
    create_table :losts do |t|
      t.integer :item_number
      t.integer :bib_number
      t.text :title
      t.text :imprint
      t.text :isbn
      t.text :status
      t.integer :checkouts
      t.text :location
      t.text :note
      t.text :call_number
      t.text :volume
      t.text :barcode
      t.date :due_date
      t.date :last_checkout

      t.timestamps
    end
  end
end
