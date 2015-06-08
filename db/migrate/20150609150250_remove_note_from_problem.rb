class RemoveNoteFromProblem < ActiveRecord::Migration
  def change
    remove_column :problems, :note, :text
  end
end
