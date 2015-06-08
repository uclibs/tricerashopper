class ChangeProblemDescriptionToNote < ActiveRecord::Migration
  def change
    rename_column :problems, :description, :note
  end
end
