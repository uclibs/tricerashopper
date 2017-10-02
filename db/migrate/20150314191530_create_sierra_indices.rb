class CreateSierraIndices < ActiveRecord::Migration[5.0]
  def change
    create_table :sierra_indices do |t|
      t.string :record_type
      t.integer :record_num
      t.datetime :last_checked

      t.timestamps
    end
    add_index :sierra_indices, :record_type
    add_index :sierra_indices, :record_num
    add_index :sierra_indices, :last_checked
  end
end
