class AddAuthorToLost < ActiveRecord::Migration
  def change
    add_column :losts, :author, :text
  end
end
