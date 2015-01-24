class CreateSerials < ActiveRecord::Migration
  def change
    create_table :serials do |t|

      t.timestamps
    end
  end
end
