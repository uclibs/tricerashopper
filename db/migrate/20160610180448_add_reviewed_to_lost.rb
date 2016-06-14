class AddReviewedToLost < ActiveRecord::Migration
  def change
    add_column :losts, :reviewed, :boolean
  end
end
