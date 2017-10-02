class ChangeProblemDescriptionToNote < ActiveRecord::Migration[5.0]
  def change
    rename_column :problems, :description, :note
  end
end
