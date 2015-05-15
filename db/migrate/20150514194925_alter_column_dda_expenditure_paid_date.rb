class AlterColumnDdaExpenditurePaidDate < ActiveRecord::Migration
  change_column :dda_expenditures, :paid_date, :date
end
