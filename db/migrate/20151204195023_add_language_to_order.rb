class AddLanguageToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :lang, :text
  end
end
