class AddOclcToLosts < ActiveRecord::Migration[5.0]
  def change
    add_column :losts, :oclc, :text
  end
end
