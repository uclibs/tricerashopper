class AddNoteFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :internal_note, :text
    add_column :orders, :processing_note, :text
  end
end
