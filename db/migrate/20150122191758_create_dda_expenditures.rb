class CreateDdaExpenditures < ActiveRecord::Migration
  def change
    create_table :dda_expenditures do |t|
      t.string :title
      t.integer :paid
      t.string :fund
      t.text :paid_date

      t.timestamps
    end
  end
end
