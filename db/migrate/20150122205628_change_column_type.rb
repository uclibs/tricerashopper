class ChangeColumnType < ActiveRecord::Migration
  def change
    change_column :dda_expenditures, :paid, :decimal, precision: 2
  end
end
