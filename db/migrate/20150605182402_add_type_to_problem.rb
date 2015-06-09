class AddTypeToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :type, :text
  end
end
