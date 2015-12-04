class AddLanguageToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :lang, :text
  end
end
