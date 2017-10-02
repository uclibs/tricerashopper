class AddAuthorToLost < ActiveRecord::Migration[5.0]
  def change
    add_column :losts, :author, :text
  end
end
