class CreateSerials < ActiveRecord::Migration
  def change
    create_table :serials do |t|
      t.integer :order_number
      t.integer :bib_number
      t.string :title
      t.string :fund
      t.string :format
      t.string :acq_type
      t.string :order_type
      t.string :vendor
      t.text :payments
      t.text :issns

      t.timestamps
    end
  end
end
