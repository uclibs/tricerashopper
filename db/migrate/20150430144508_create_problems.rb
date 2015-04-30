class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.text :title
      t.integer :record_num
      t.string :record_type
      t.text :description

      t.timestamps
    end
  end
end
