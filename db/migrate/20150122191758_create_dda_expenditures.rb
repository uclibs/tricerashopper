class CreateDdaExpenditures < ActiveRecord::Migration
  def change
    create_table :dda_expenditures do |t|
      t.text :title
      t.decimal :paid
      t.string :fund
      t.date :paid_date

      t.timestamps
    end
  end
end
