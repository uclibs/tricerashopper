class AddTypeToProblem < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :type, :text
  end
end
