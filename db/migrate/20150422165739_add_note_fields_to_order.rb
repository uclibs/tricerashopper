class AddNoteFieldsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :internal_note, :text
    add_column :orders, :processing_note, :text
  end
end
