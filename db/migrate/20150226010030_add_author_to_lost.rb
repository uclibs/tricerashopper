class AddAuthorToLost < ActiveRecord::Migration
  def change
    add_column :losts, :author, :string
  end
end
