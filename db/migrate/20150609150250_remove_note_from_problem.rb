class RemoveNoteFromProblem < ActiveRecord::Migration[5.0]
  def change
    remove_column :problems, :note, :text
  end
end
