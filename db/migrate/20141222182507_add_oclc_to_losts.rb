class AddOclcToLosts < ActiveRecord::Migration
  def change
    add_column :losts, :oclc, :text
  end
end
