class AddReviewedToLost < ActiveRecord::Migration[5.0]
  def change
    add_column :losts, :reviewed, :boolean
  end
end
